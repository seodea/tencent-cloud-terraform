# Create privileges
resource "tencentcloud_mysql_privilege" "privilege" {
  mysql_id     = tencentcloud_mysql_instance.tf_mysql.id
  account_name = tencentcloud_mysql_account.mysql_account.name
  
  # All permission
  global       = ["PROCESS","SHOW DATABASES","SELECT", "INSERT", "UPDATE", "DELETE", "CREATE", 
                "DROP", "REFERENCES", "INDEX", "ALTER", "CREATE TEMPORARY TABLES", "LOCK TABLES",
                "EXECUTE", "CREATE VIEW", "SHOW VIEW", "CREATE ROUTINE", "ALTER ROUTINE", "EVENT", "TRIGGER"]
  database {
    privileges    = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE"]
    database_name = "sys"
  }
  database {
    privileges    = ["SELECT"]
    database_name = "performance_schema"
  }

  table {
    privileges    = ["SELECT", "INSERT", "UPDATE", "DELETE", "CREATE"]
    database_name = "mysql"
    table_name    = "slow_log"
  }

  table {
    privileges    = ["SELECT", "INSERT", "UPDATE"]
    database_name = "mysql"
    table_name    = "user"
  }

  column {
    privileges    = ["SELECT", "INSERT", "UPDATE", "REFERENCES"]
    database_name = "mysql"
    table_name    = "user"
    column_name   = "host"
  }

}