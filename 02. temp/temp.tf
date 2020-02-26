provider "tencentcloud" {
  secret_id  = var.secret_id
  secret_key = var.secret_key
  region     = var.region
}

data "tencentcloud_availability_zones" "my_favorate_zones" {}

data "tencentcloud_images" "my_favorate_image" {
  image_type = ["PUBLIC_IMAGE"]
  os_name    = "centos"
}

# Create VPC and Subnet
resource "tencentcloud_vpc" "main" {
  name       = "terraform test"
  cidr_block = "10.6.0.0/16"
}

resource "tencentcloud_subnet" "main_subnet" {
  vpc_id            = tencentcloud_vpc.main.id
  name              = "terraform test subnet"
  cidr_block        = "10.6.7.0/24"
  availability_zone = var.availability_zone
  route_table_id    = tencentcloud_route_table.tf_routetable.id

  tags = var.tags

}

# Create EIP
resource "tencentcloud_eip" "eip_dev_dnat" {
  name = "terraform_test"
}


# Create NAT Gateway
resource "tencentcloud_nat_gateway" "my_nat" {
  vpc_id         = tencentcloud_vpc.main.id
  name           = "terraform test"
  max_concurrent = 1000000
  bandwidth      = 100

  assigned_eip_set = [
    tencentcloud_eip.eip_dev_dnat.public_ip,
  ]
}

# Create Route Tables

resource "tencentcloud_route_table" "tf_routetable" {
  vpc_id = tencentcloud_vpc.main.id
  name   = "tf-rt"
}

resource "tencentcloud_route_table_entry" "internet" {
  route_table_id         = tencentcloud_route_table.tf_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = tencentcloud_nat_gateway.my_nat.id
  
  depends_on = [tencentcloud_nat_gateway.my_nat] 
  description            = "nat-route-table-entry"
}

data "tencentcloud_instance_types" "my_favorate_instance_types" {
  filter {
    name   = "instance-family"
    values = ["S2"]
  }

  cpu_core_count = 1
  memory_size    = 1
}

# Create CVM
#resource "tencentcloud_instance" "foo" {
#  availability_zone = var.availability_zone
#  image_id          = data.tencentcloud_images.my_favorate_image.images.0.image_id
#  instance_type     = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types.0.instance_type
#  vpc_id            = tencentcloud_vpc.main.id
#  subnet_id         = tencentcloud_subnet.main_subnet.id
#  system_disk_type  = "CLOUD_PREMIUM"
#  password          = "Tencent-test"
#}

# Create a web server without public ip 
resource "tencentcloud_instance" "web" {
  instance_name              = "tf-temp-web"
  availability_zone          = var.availability_zone
  image_id                   = data.tencentcloud_images.my_favorate_image.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  hostname                   = "tf-temp-web"
  vpc_id                     = tencentcloud_vpc.main.id
  subnet_id                  = tencentcloud_subnet.main_subnet.id
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

resource "tencentcloud_security_group_rule" "icmp" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "egress"
  cidr_ip           = "0.0.0.0/0"
  ip_protocol       = "all"
  policy            = "accept"
}