# Tests for database connection functions
# Note: These tests check function behaviour without requiring actual DB connection

test_that("get_dw_connection validates environment variables", {
 # Save current env vars
 host_backup <- Sys.getenv("DATAWAREHOUSE_HOST")
 user_backup <- Sys.getenv("DATAWAREHOUSE_USER")
 pass_backup <- Sys.getenv("DATAWAREHOUSE_PASSWORD")

 # Clear env vars
 Sys.unsetenv("DATAWAREHOUSE_HOST")
 Sys.unsetenv("DATAWAREHOUSE_USER")
 Sys.unsetenv("DATAWAREHOUSE_PASSWORD")

 # Test that function errors when HOST is missing
 expect_error(
 get_dw_connection(),
 regexp = "DATAWAREHOUSE_HOST"
 )

 # Set HOST, test USER missing
 Sys.setenv(DATAWAREHOUSE_HOST = "test_host")
 expect_error(
 get_dw_connection(),
 regexp = "DATAWAREHOUSE_USER"
 )

 # Set USER, test PASSWORD missing
 Sys.setenv(DATAWAREHOUSE_USER = "test_user")
 expect_error(
 get_dw_connection(),
 regexp = "DATAWAREHOUSE_PASSWORD"
 )

 # Restore original env vars
 if (nchar(host_backup) > 0) Sys.setenv(DATAWAREHOUSE_HOST = host_backup) else Sys.unsetenv("DATAWAREHOUSE_HOST")
 if (nchar(user_backup) > 0) Sys.setenv(DATAWAREHOUSE_USER = user_backup) else Sys.unsetenv("DATAWAREHOUSE_USER")
 if (nchar(pass_backup) > 0) Sys.setenv(DATAWAREHOUSE_PASSWORD = pass_backup) else Sys.unsetenv("DATAWAREHOUSE_PASSWORD")
})

test_that("get_dw_db_example validates type argument", {
 expect_error(get_dw_db_example(type = "invalid"))
})

test_that("get_dw_db_example accepts valid types", {
 # These should not error, just print output
 expect_output(get_dw_db_example(type = "sql"))
 expect_output(get_dw_db_example(type = "table"))
})
