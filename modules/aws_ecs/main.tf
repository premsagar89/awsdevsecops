/* ECS CLOUDWATCH GROUP */
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "${var.ecsName}"
}

/* ECS CLUSTER */
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.ecsClusterName}"
  configuration {
    execute_command_configuration {
      kms_key_id = "${var.kmsKeyId}"
      logging = "${var.confLogging}"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
        cloud_watch_encryption_enabled = true
      }
    }
  }
}

/* ECS TASK DEFINITION */
resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "${var.ecsTaskFamily}"
  container_definitions    = file("${path.module}/containerdef.json")

  runtime_platform {
    operating_system_family = "${var.OSFamily}"
    cpu_architecture = "${var.CPUArch}"
  }
  
  ephemeral_storage {
    size_in_gib = "${var.ephemeralStorage}"
  }
  
  network_mode             = "${var.networkMode}"
  requires_compatibilities = ["${var.requiresCompatibilities}"]
  cpu                      = "${var.fargateCPU}"
  memory                   = "${var.fargateMemory}"
  execution_role_arn       = "arn:aws:iam::949307570634:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  task_role_arn            = "arn:aws:iam::949307570634:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}

/* ECS SERVICE */
resource "aws_ecs_service" "ecs_service" {
  name              = "${var.ecsServiceName}"
  launch_type       = "${var.launchType}"
  task_definition   = "${aws_ecs_task_definition.ecs_task_def.arn}"
  platform_version  = "${var.platformVersion}"
  cluster           = aws_ecs_cluster.ecs_cluster.id
  desired_count     = "${var.nodeCount}"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent = 200

  deployment_controller {
    type = "${var.deploymentControllerType}"
  }

  load_balancer {
    target_group_arn = "${var.targetGrpArn}" //aws_lb_target_group.foo.arn
    container_name   = "${var.containerName}"
    container_port   = "${var.containerPort}"
  }

  network_configuration {
    subnets = [ for sn in "${var.vpcSubnets}" : sn ]
  }
}




