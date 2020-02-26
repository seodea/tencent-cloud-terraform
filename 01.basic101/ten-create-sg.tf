# Create security group of CVM with 4 rules
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

resource "tencentcloud_security_group_rule" "egrees_any" {
  security_group_id = tencentcloud_security_group.web_sg.id
  type              = "egress"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
}

# Create security group of DB with 2 rules
resource "tencentcloud_security_group" "db_sg" {
  name        = "db-sg"
  description = "make it accessible for both production and stage ports"
}

resource "tencentcloud_security_group_rule" "web" {
  security_group_id = tencentcloud_security_group.db_sg.id
  type              = "ingress"
  cidr_ip           = tencentcloud_subnet.tf_service_subnet.cidr_block
  ip_protocol       = "tcp"
  port_range        = "3306"
  policy            = "accept"
}


resource "tencentcloud_security_group_rule" "egrees_any" {
  security_group_id = tencentcloud_security_group.db_sg.id
  type              = "egress"
  cidr_ip           = "0.0.0.0/0"
  policy            = "accept"
}