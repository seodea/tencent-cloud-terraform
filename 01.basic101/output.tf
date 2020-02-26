#output "instance_type" {
#  value = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types
#}
#

output "zone" {
  value = data.tencentcloud_availability_zones.my_favorate_zones.zones
}

output "nat_eip"{
  value = tencentcloud_eip.eip_dev_dnat.public_ip
}

output "route_table"{
  value = tencentcloud_route_table.tf_routetable.id
}

# RDS info