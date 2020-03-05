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
  instance_name              = "tf-temp-web-${count.index}"
  #name  = "neo.${count.index}"
  availability_zone          = var.availability_zone
  image_id                   = data.tencentcloud_images.my_favorate_image.images.0.image_id
  instance_type              = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types.0.instance_type
  system_disk_type           = "CLOUD_PREMIUM"
  hostname                   = "tf-temp-web-${count.index}"
  vpc_id                     = tencentcloud_vpc.tf_vpc.id
  subnet_id                  = tencentcloud_subnet.tf_service_subnet.id
  internet_max_bandwidth_out = 100 # 0 - 100
  count                      = 2
  security_groups            = [tencentcloud_security_group.web_sg.id]
  password                   = var.password
  #allocate_public_ip        = [tencentcloud_eip.ecs_eip.public_id]
  
  #data_disks {
  #  data_disk_type = "CLOUD_PREMIUM"
  #  data_disk_size = 50
  #}

  tags = {
      test = "tf-test"
  }
}

