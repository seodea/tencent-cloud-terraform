#output "ecs_ip"{
#    value = tencentcloud_instance.web.public_ip
#}

#output "instance_type" {
#  value = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types
#}


output "zone" {
  value = data.tencentcloud_availability_zones.my_favorate_zones.zones
}
