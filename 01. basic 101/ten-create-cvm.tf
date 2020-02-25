data "tencentcloud_images" "my_favorate_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

data "tencentcloud_instance_types" "my_favorate_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S2"]
  }

  cpu_core_count = 1
  memory_size    = 1
}

data "tencentcloud_availability_zones" "my_favorate_zones" {


}

# Create a web server without public ip 
resource "tencentcloud_instance" "web" {
  instance_name              = "tf-temp-web"
  availability_zone          = var.availability_zone
  image_id                   = data.tencentcloud_images.my_favorate_image.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  hostname                   = "tf-temp-web"
  vpc_id                     = tencentcloud_vpc.tf_vpc.id
  subnet_id                  = tencentcloud_subnet.tf_subnet.id
  internet_max_bandwidth_out = 100 # 0 - 100
  count                      = 1
  security_groups            = [tencentcloud_security_group.web_sg.id]
  password                   = var.cvm_password
  #allocate_public_ip        = [tencentcloud_eip.ecs_eip.public_id]
  
  #data_disks {
  #  data_disk_type = "CLOUD_PREMIUM"
  #  data_disk_size = 50
  #}

  tags = {
      test = "tf-test"
  }
}

# Create security group with 2 rules
resource "tencentcloud_security_group" "web_sg" {
  name        = "web-sg"
  description = "make it accessible for both production and stage ports"
}

resource "tencentcloud_security_group_rule" "web" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "80"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "ssh" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "tcp"
  port_range        = "22"
  policy            = "accept"
}

resource "tencentcloud_security_group_rule" "icmp" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "ingress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "icmp"
  policy            = "accept"
}