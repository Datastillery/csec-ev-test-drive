module "ApiGetScheduleRole" {
  source = "./modules/roles/create_lambda_role"
  lambda_role_name = "${var.environment}ApiGetScheduleRole"
}

module "ApiGetScheduleFunction" {
  source = "./modules/lambda/create_lambda_function_in_vpc_with_env_variables"
  function_name = "${var.environment}ApiGetSchedule"
  handler = "src/api/admin/GetSchedule.handler"
  role_arn = "${module.ApiGetScheduleRole.arn}"
  timeout = "10"
  description = "Api to get schedule"
  vpc_subnet_ids = [
    "${aws_subnet.Subnet2.id}",
    "${aws_subnet.Subnet3.id}"]
  vpc_security_group_ids = [
    "${aws_security_group.LambdaSecurityGroup.id}"]
  environment = {
    variables = {
      host = "${aws_db_instance.smartexperience_mysql_db.address}"
      user = "${var.user}"
      password = "${var.password}"
    }
  }
}