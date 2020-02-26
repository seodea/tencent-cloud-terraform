resource "tencentcloud_clb_instance" "web_clb" {
  network_type              = "OPEN"
  clb_name                  = "myclb"
  project_id                = 0
  vpc_id                    = tencentcloud_vpc.tf_vpc.id
  #security_groups           = ["Fill SG ID out "]
  target_region_info_region = var.region
  target_region_info_vpc_id = tencentcloud_vpc.tf_vpc.id

  tags = {
    test = "tf"
  }
}

# Create CLB TCP Listener Rule
resource "tencentcloud_clb_listener" "tcp_listener_80" {
  clb_id                     = tencentcloud_clb_instance.web_clb.id
  listener_name              = "tf_80_listener"
  port                       = 80
  protocol                   = "TCP"
  health_check_switch        = true
  health_check_time_out      = 2
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  session_expire_time        = 30
  scheduler                  = "WRR"
}

# Create CLB attachment CVM
resource "tencentcloud_clb_attachment" "web_cvm_attach" {
  clb_id      = tencentcloud_clb_instance.web_clb.id
  listener_id = tencentcloud_clb_listener.tcp_listener_80.id
  #it is only supported listeners of 'HTTP' and 'HTTPS'.
  #rule_id     = "loc-4xxr2cy7"

  targets {
    # IF you have only the one CVM, You have to put on the 0 between web and id
    instance_id = tencentcloud_instance.web[0].id
    port        = 80
    weight      = 10
  }
}