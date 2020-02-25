# Configure the TencentCloud Provider

provider "tencentcloud" {
  secret_id  = var.secret_id
  secret_key = var.secret_key
  region     = var.region
}


resource "tencentcloud_vpc" "tf_vpc" {
  name       = "tf-tmp-vpc"
  cidr_block = "192.168.0.0/16"

  #tags = {
  #    test = var.tags
  #}
}

resource "tencentcloud_subnet" "tf_subnet" {
  vpc_id            = tencentcloud_vpc.tf_vpc.id
  name              = "terraform test subnet"
  cidr_block        = "192.168.1.0/24"

  #name              = "tf-tmp-subnet"
  #vpc_id            = tencentcloud_vpc.tf_vpc.id
  #cidr_block        = "10.0.1.0/24"
  # is_multicast      = false #default is True
  
  availability_zone = var.availability_zone
  route_table_id    = tencentcloud_route_table.tf_routetable.id

  tags = var.tags

}

resource "tencentcloud_route_table" "tf_routetable" {
  vpc_id = tencentcloud_vpc.tf_vpc.id
  name   = "tf-rt"
}

resource "tencentcloud_route_table_entry" "internet" {
  route_table_id         = tencentcloud_route_table.tf_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = tencentcloud_nat_gateway.nat.id
  
  depends_on = [tencentcloud_nat_gateway.nat] 
  description            = "nat-route-table-entry"
}
#