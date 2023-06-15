/* CODE DEPLOYMENT APPLICATION */
resource "aws_codedeploy_app" "codedeploy_app" {
  name = "${var.appName}"
  compute_platform = "${var.computePlatform}" // Optiones Avialable: "ECS", "Lambda", "Server"
}

/* CODE DEPLOYMENT GROUP */
resource "aws_codedeploy_deployment_group" "code_deployment_group" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "${var.appName}-group"
  deployment_config_name = "${var.deploymentConfigname}" // Other Options Available: "CodeDeployDefault.LambdaAllAtOnce", "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn      = "${var.serviceRole}"

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
  deployment_style {
    deployment_option = "${var.deploymentOption}" // Other Options Available: "WITH_TRAFFIC_CONTROL", "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "${var.deploymentType}" // Other Options Available: "BLUE_GREEN", "IN_PLACE"
  }

/* BELOW BLOCKS ARE USED FOR ECS BLUE-GREEN DEPLOYMENT */

/* ################### START ################### */
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }
  
  ecs_service {
    cluster_name = "${var.clusterName}"
    service_name = "${var.clusterServiceName}"
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = ["${var.listenerArn}"]
      }

      target_group {
        name = "${var.targetGrp1Arn}"
      }

      target_group {
        name = "${var.targetGrp2Arn}"
      }
    }
  }
/* ################### END ################### */
}