# Create EIP
resource "tencentcloud_eip" "nat_eip" {
    name = "nat_eip"
    depends_on = [tencentcloud_vpc.tf_vpc]
}

resource "tencentcloud_nat_gateway" "nat" {
    name             = "tf-nat"
    vpc_id           = tencentcloud_vpc.tf_vpc.id
    bandwidth        = 200
    max_concurrent   = 1000000
    assigned_eip_set = [
        tencentcloud_eip.nat_eip.public_ip,
    ] # 어떤 상태가 나오는지 확인해보
    depends_on = [tencentcloud_vpc.tf_vpc]
}

