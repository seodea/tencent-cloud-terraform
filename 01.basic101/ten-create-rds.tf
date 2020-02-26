#Create MYSQL

resource "tencentcloud_mysql_instance" "tf_mysql" {
  internet_service = 1
  engine_version   = "5.7"

  root_password     = "********"
  slave_deploy_mode = 0
  first_slave_zone  = "ap-seoul-1"
  second_slave_zone = "ap-seoul-1"
  slave_sync_mode   = 1
  availability_zone = "ap-seoul-1"
  #engin version
  engine_version    = var.dbengine
  instance_name     = "tf-Mysql"
  mem_size          = 1000 # 1000MB부터 - x2 till 488000MB
  volume_size       = 25
  vpc_id            = tencentcloud_vpc.tf_vpc.id
  subnet_id         = tencentcloud_subnet.tf_db_subnet.id
  intranet_port     = 3306
  security_groups   = tencentcloud_security_group.db_sg.id

  internet_service  = "1"

  tags = {
    name = "test"
  }

  parameters = {
    max_connections = "1000"
  }
}

data "tencentcloud_mysql_parameter_list" "mysql" {
  mysql_id = tencentcloud_mysql_instance.tf_mysql.id
}

# Create Account
resource "tencentcloud_mysql_account" "mysql_account" {
  mysql_id    = "my-test-database"
  name        = "mysqladmin"
  password    = "Tencent-test"
  description = "My test account"
}

# Create privileges
resource "tencentcloud_mysql_privilege" "privilege" {
  mysql_id     = tencentcloud_mysql_instance.tf_mysql.id
  account_name = tencentcloud_mysql_account.mysql_account.name
  global       = ["TRIGGER"]
  
  database {
    privileges    = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE"]
    database_name = "sys"
  }

  table {
    privileges    = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE"]
    database_name = "mysql"
    table_name    = "slow_log"
  }

  column {
    privileges    = ["SELECT", "INSERT", "UPDATE", "REFERENCES"]
    database_name = "mysql"
    table_name    = "user"
    column_name   = "host"
  }
}