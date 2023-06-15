#################################################
/* AWS KMS KEY */
#################################################
module "aws_kms" {
    source = "./modules/aws_kms"
    kmsUsage = "ENCRYPT_DECRYPT"
    kmsDesc = "kMS Key For Testing"
    deletionWindow = 30
}
output "aws_kms" {
    value = module.aws_kms
}

#################################################
/* AWS IAM */
#################################################
module "aws_iam" {
    source = "./modules/aws_iam"
    depends_on = [ module.aws_kms ]
    roleName = "AWSDemoManagedRole"
    roleDesc = "Demo IAM Managed Role"
    roleTrustPolicy = [
        "ec2.amazonaws.com",
        "lambda.amazonaws.com",
        "codecommit.amazonaws.com",
        "codebuild.amazonaws.com",
        "codedeploy.amazonaws.com",
        "codepipeline.amazonaws.com",
        "cloudformation.amazonaws.com",
        "elasticbeanstalk.amazonaws.com"
    ]
    policyName = "AWSDemoManagedPolicy"
    policyDesc = "Demo IAM Managed Policy"
    policyPermission = [
        "iam:CreateRole",
        "iam:GetPolicy",
        "iam:AttachRolePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:GetPolicyVersion",
        "iam:ListRoles",
        "iam:ListGroups",
        "iam:ListUsers",
        "iam:PassRole",
        "s3:*",
        "lambda:*",
        "kms:*",
        "cloudwatch:*",
        "autoscalling:*",
        "cloudformation:CreateStack",
        "cloudformation:UpdateStack",
        "cloudformation:DescribeStack",
        "cloudformation:DeleteStack",
        "cloudformation:CreateChangeSet",
        "cloudformation:DeleteChangeSet",
        "cloudformation:DescribeChangeSet",
        "cloudformation:ExecuteChangeSet",
        "cloudformation:SetStackPolicy",
        "cloudformation:ValidateTemplate",
        "opswork:DescribeApps",
        "opswork:DescribeCommands",
        "opswork:DescribeDeployments",
        "opswork:DescribeInstances",
        "opswork:DescribeStacks",
        "opswork:UpdateApps",
        "opswork:UpdateStacks",
        "ecr:*",
        "ecs:*",
        "elasticloadbalancing:DescribeTargetGroups",
        "elasticloadbalancing:DescribeListeners",
        "elasticloadbalancing:ModifyListeners",
        "elasticloadbalancing:DescribeRules",
        "elasticloadbalancing:ModifyRule",
        "ssm:DescribeParameters",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "codecommit:*",
        "codebuild:*",
        "codedeploy:*",
        "codepipeline:*"
    ]
    attachPolicyArn = [
        "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
        "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    ]
}
output "aws_iam" {
    value = module.aws_iam
}

#################################################
/* AWS Security Group */
#################################################
module "aws_security_group" {
    source = "./modules/aws_security_group"
    /* depends_on = [ module.aws_iam ] */
    sgName = "demosg"
    sgDesc = "Security Group"
    vpcID = "${var.defaultVPC}"
    ingressRules = [
        {from_port = 80, to_port = 80, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"], description = "Allowed Port 80"},
        {from_port = 443, to_port = 443, protocol = "TCP", cidr_blocks = ["0.0.0.0/0"], description = "Allowed Port 443"}
    ]
}
output "aws_security_group" {
    value = module.aws_security_group
}

#################################################
/* AWS EC2 Instance */
#################################################
module "aws_sshkeypair" {
    source = "./modules/aws_sshkeypair"
    depends_on = [ module.aws_security_group ]
    for_each = toset([ "one", "two", "three" ])
    sshKeyPairName = "sshkeypair-${each.value}"
}
output "aws_sshkeypair" {
    value = module.aws_sshkeypair
}

#################################################
/* AWS EC2 Instance */
#################################################
module "aws_ec2" {
    source = "./modules/aws_ec2"
    depends_on = [ module.aws_sshkeypair ]
    amiID = "ami-04a0ae173da5807d3"
    instanceType = "t2.micro"
    availabilityZone = "${var.availabilityZone[0]}"
    sgID = [
        "${module.aws_security_group.sg_id}",
        "${var.defaultVPCSecurityGroup}"
    ]
    subnetID = "${var.defaultVPCSubnets[0]}"
    sshKeyPairName = "sshkeypair-one"
}
output "aws_ec2" {
    value = module.aws_ec2
}

#################################################
/* AWS S3 */
#################################################
module "aws_s3" {
    source = "./modules/aws_s3"
    depends_on = [ module.aws_ec2 ]
    bucketName = "demobucket"
}
output "aws_s3" {
    value = module.aws_s3
}

#################################################
/* AWS LAMBDA */
#################################################
module "aws_lambda" {
    source = "./modules/aws_lambda"
    depends_on = [ module.aws_s3 ]
    lambdaFuncName = "DemoLambda"
    roleARN = "${module.aws_iam.iam_role_arn}"
    lambdaHandler = "lambda_function.lambda_handler"
    lambdaRuntime = "python3.9"
    lambdaImageUri = "${var.accountID}.dkr.ecr.${var.region}.amazonaws.com/base_images:nginx"
    packageType = "Image"
    ephemeralStorage = 10240 # Min 512 MB and the Max 10240 MB
}
output "aws_lambda" {
    value = module.aws_lambda
}

#################################################
/* AWS ECR */
#################################################
module "aws_ecr" {
    source = "./modules/aws_ecr"
    depends_on = [ module.aws_lambda ]
    ecrName = "democontainer" // Container name should be in SMALL LETTER
    ecrImageTagMutability = "MUTABLE"
}
output "aws_ecr" {
    value = module.aws_ecr
}

#################################################
/* AWS ELB */
#################################################
module "aws_elb" {
    source = "./modules/aws_elb"
    depends_on = [ module.aws_ecr ]
    albName = "demoALB"
    albType = "application"
    sgID = "${module.aws_security_group.sg_id}"
    vpcID = "${var.defaultVPC}"
    subnetID = "${var.defaultVPCSubnets}"

    tg1 = "demoALB-tg1"
    tg2 = "demoALB-tg2"
    
    albAlgoType = "round_robin"
    albTargetType = "ip"
    albTGProtocol = "HTTP"
    albTGPort = 80

    albListener1Protocol = "HTTP"
    albListener1Port = 80
    albListener1ActionType = "forward"

    albListener2Protocol = "HTTP"
    albListener2Port = 81
    albListener2ActionType = "forward"
}
output "aws_elb" {
    value = module.aws_elb
}

#################################################
/* AWS ECS */
#################################################
module "aws_ecs" {
    source = "./modules/aws_ecs"
    depends_on = [ module.aws_elb ]

    ecsName = "demo"

    ecsClusterName = "democluster"
    kmsKeyId = "${module.aws_kms.kms_id}"
    confLogging = "OVERRIDE"

    ecsTaskFamily = "demo" // also mentioned in "taskdef.json" file
    OSFamily = "LINUX"
    CPUArch = "X86_64"
    ephemeralStorage = 21
    networkMode = "awsvpc"
    vpcSubnets = "${var.defaultVPCSubnets}"
    requiresCompatibilities = "FARGATE"
    fargateCPU = 512
    fargateMemory = 1024

    ecsServiceName = "democlusterservice"
    launchType = "FARGATE"
    platformVersion = "LATEST"
    nodeCount = 2
    // iamRoleArn = "arn:aws:iam::${var.accountID}:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
    deploymentControllerType = "CODE_DEPLOY" // Other Available Values: "CODE_DEPLOY", "ECS", "EXTERNAL". Default: "ECS"
    targetGrpArn = "${module.aws_elb.alb_tg1_arn}"
    containerName = "demoContainer1" // This name MUST match with the name mentioned in the "containerdef.json" and "appspec.yml" file
    containerPort = 80
    
}
output "aws_ecs" {
    value = module.aws_ecs
}

#################################################
/* AWS CODECOMMIT */
#################################################
module "aws_codecommit" {
    source = "./modules/aws_codecommit"
    depends_on = [ module.aws_ecs ]
    repositoryName = "DemoRepo"
    defaultBranch = "master"
    description = "This is the Sample App Repository"
}
output "aws_codecommit" {
    value = module.aws_codecommit
}

#################################################
/* AWS CODE BUILD */
#################################################
module "aws_codebuild" {
    source = "./modules/aws_codebuild"
    depends_on = [ module.aws_codecommit ]
    projectName = "DemoProject"
    projectDesc = "Sample Demo Project for Testing"
    cloudwatchLogGroupName = "DemoLogGroup"
    cloudwatchLogStreamName = "DemoLogStream"
    serviceRole = "${module.aws_iam.iam_role_arn}"
    srcType = "CODECOMMIT"
    srcLocation = "${module.aws_codecommit.codecommit_repository_clone_url_http}"
    artifactType = "NO_ARTIFACTS"
    envType = "LINUX_CONTAINER"
    envComputeType = "BUILD_GENERAL1_SMALL"

    buildSpecFilePath = "${path.module}/configuration/buildspec.yml"
    scaBuildSpecFilePath = "${path.module}/configuration/buildspec-owasp-depedency-check.yml"
    sastBuildSpecFilePath = "${path.module}/configuration/buildspec-phpstan.yml"
    dastBuildSpecFilePath = "${path.module}/configuration/buildspec-owasp-zap.yml"
}
output "aws_codebuild" {
    value = module.aws_codebuild
}

#################################################
/* AWS CODE DEPLOY */
#################################################
module "aws_codedeploy" {
    source = "./modules/aws_codedeploy"
    depends_on = [ module.aws_codebuild ]
    appName = "DemoApp"
    computePlatform = "ECS" // Optiones Avialable: "ECS", "Lambda", "Server"
    deploymentConfigname = "CodeDeployDefault.ECSAllAtOnce" // Other Options Available: "CodeDeployDefault.LambdaAllAtOnce", "CodeDeployDefault.ECSAllAtOnce"
    serviceRole = "${module.aws_iam.iam_role_arn}"
    deploymentOption = "WITH_TRAFFIC_CONTROL" // Other Options Available: "WITH_TRAFFIC_CONTROL", "WITHOUT_TRAFFIC_CONTROL"
    deploymentType = "BLUE_GREEN" // Other Options Available: "BLUE_GREEN", "IN_PLACE"
    clusterName = "${module.aws_ecs.ecs_cluster_name}"
    clusterServiceName = "${module.aws_ecs.ecs_cluster_service_name}"
    listenerArn = "${module.aws_elb.alb_listener1_arn}"
    targetGrp1Arn = "${module.aws_elb.alb_tg1_arn}"
    targetGrp2Arn = "${module.aws_elb.alb_tg2_arn}"
}
output "aws_codedeploy" {
    value = module.aws_codedeploy
}

#################################################
/* AWS CODE PIPELINE */
#################################################
module "aws_codepipeline" {
    source = "./modules/aws_codepipeline"
    depends_on = [ module.aws_codedeploy ]
    pipelineName = "DemoPipeline"
    serviceRole = "${module.aws_iam.iam_role_arn}"
    artifactLocation = "${module.aws_s3.bucket}"
    encryptionKeyId = "${module.aws_kms.kms_id}"

    repoName = "${module.aws_codecommit.codecommit_repository_name}"
    branchName = "${module.aws_codecommit.codecommit_repository_default_branch}"

    buildProjectName = "${module.aws_codebuild.codebuild_project_name}"
    scaBuildProjectName = "${module.aws_codebuild.codebuild_project_name}"
    sastBuildProjectName = "${module.aws_codebuild.codebuild_project_name}"
    dastBuildProjectName = "${module.aws_codebuild.codebuild_project_name}"

    appName = "${module.aws_codedeploy.codedeploy_app_name}"
    deploymentGroupName = "${module.aws_codedeploy.code_deployment_group_name}"
    defArtifact = "DefinitionArtifact"
    taskDefJSON = "${path.module}/configuration/taskdef.json"
    appSpecJSON = "${path.module}/configuration/appspec.yml"
    imgArtifact = "ImageArtifact"
    imgContainerName = "IMAGE1_NAME"
}
output "aws_codepipeline" {
    value = "${module.aws_codepipeline}"
}
