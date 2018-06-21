resource "aws_api_gateway_rest_api" "SmartExperienceApi" {
  name        = "SmartExperience"
  description = "Smart Experience API for test drive registration and survey"
}

resource "aws_api_gateway_deployment" "event_stage" {
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  stage_name  = "test"
}

resource "aws_api_gateway_usage_plan" "DefaultUseagePlan" {
  name         = "default-usage-plan"
  description  = "default description"
  product_code = "SMARTEXPERIENCE"

  api_stages {
    api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
    stage  = "${aws_api_gateway_deployment.event_stage.stage_name}"
  }
}

resource "aws_api_gateway_api_key" "Smart_Experience_Key" {
  name = "Smart_Experience_Key"

  stage_key {
    rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
    stage_name  = "${aws_api_gateway_deployment.event_stage.stage_name}"
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = "${aws_api_gateway_api_key.Smart_Experience_Key.id}"
  key_type      = "API_KEY"
  usage_plan_id = "${aws_api_gateway_usage_plan.DefaultUseagePlan.id}"
}

module "api_post_user" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "user"
  function_invoke_arn = "${module.ApiSaveUserFunction.invoke_arn}"
  function_arn = "${module.ApiSaveUserFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "POST"
}

module "api_get_cars" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "cars"
  function_invoke_arn = "${module.ApiGetCarsFunction.invoke_arn}"
  function_arn = "${module.ApiGetCarsFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}

module "api_get_timeSlots" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "timeSlots"
  function_invoke_arn = "${module.ApiGetTimeSlotsFunction.invoke_arn}"
  function_arn = "${module.ApiGetTimeSlotsFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}

module "api_get_preSurvey" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "preSurvey"
  function_invoke_arn = "${module.ApiGetPreSurveyFunction.invoke_arn}"
  function_arn = "${module.ApiGetPreSurveyFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}

module "api_get_postSurvey" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "postSurvey"
  function_invoke_arn = "${module.ApiGetPostSurveyFunction.invoke_arn}"
  function_arn = "${module.ApiGetPostSurveyFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}

module "api_post_saveSurvey" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "survey"
  function_invoke_arn = "${module.ApiSaveSurveyFunction.invoke_arn}"
  function_arn = "${module.ApiSaveSurveyFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "POST"
}

module "api_post_scheduleDrive" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "drive"
  function_invoke_arn = "${module.ApiScheduleDriveFunction.invoke_arn}"
  function_arn = "${module.ApiScheduleDriveFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "POST"
}

module "api_get_schedule" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "schedule"
  function_invoke_arn = "${module.ApiGetScheduledDrivesFunction.invoke_arn}"
  function_arn = "${module.ApiGetScheduledDrivesFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}

module "api_get_user" {
  source = "./modules/api/create_gateway_method_for_lambda"
  parent_id = "${aws_api_gateway_rest_api.SmartExperienceApi.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.SmartExperienceApi.id}"
  path = "getUser"
  function_invoke_arn = "${module.ApiGetUserFunction.invoke_arn}"
  function_arn = "${module.ApiGetUserFunction.arn}"
  api_key_required = "true"
  account_number = "${var.account_number}"
  method = "GET"
}