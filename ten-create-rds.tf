#Create MYSQL

resource "tencentcloud_mysql_instance" "tf_mysql" {
  internet_service = 1
  #engin version
  engine_version    = var.dbengine

  root_password     = "P@ssw0rd"
  slave_deploy_mode = 0
  first_slave_zone  = var.availability_zone
  second_slave_zone = var.availability_zone
  slave_sync_mode   = 1
  availability_zone = var.availability_zone
  
  instance_name     = "tf-Mysql"
  mem_size          = 1000 # 1000MB부터 - x2 till 488000MB
  volume_size       = 25
  vpc_id            = tencentcloud_vpc.tf_vpc.id
  subnet_id         = tencentcloud_subnet.tf_db_subnet.id
  intranet_port     = 3306
  security_groups   = [tencentcloud_security_group.db_sg.id,
    ]

  tags = {
    method = "test"
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
  mysql_id    = tencentcloud_mysql_instance.tf_mysql.id
  name        = "mysqladmin"
  password    = var.password
  description = "My test account"
}

# Create privileges
resource "tencentcloud_mysql_privilege" "privilege" {
  mysql_id     = tencentcloud_mysql_instance.tf_mysql.id
  account_name = tencentcloud_mysql_account.mysql_account.name
  
  # All permission
  global       = ["PROCESS","SHOW DATABASES","SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", "DROP", "REFERENCES", "INDEX", "ALTER", "CREATE TEMPORARY TABLES", "LOCK TABLES","EXECUTE", "CREATE VIEW", "SHOW VIEW", "CREATE ROUTINE", "ALTER ROUTINE", "EVENT", "TRIGGER"]
  
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