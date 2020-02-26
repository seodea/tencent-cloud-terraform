#output "instance_type" {
#  value = data.tencentcloud_instance_types.my_favorate_instance_types.instance_types
#}
#

output "zone" {
  value = data.tencentcloud_availability_zones.my_favorate_zones.zones
}

output "nat_eip"{
  value = tencentcloud_eip.nat_eip.public_ip
}

output "route_table"{
  value = tencentcloud_route_table.tf_routetable.id
}

# RDS info 
output "mysql_internet_host" {
  value = tencentcloud_mysql_instance.tf_mysql.internet_host
}

output "mysql_internet_port" {
  value = tencentcloud_mysql_instance.tf_mysql.internet_port
}
