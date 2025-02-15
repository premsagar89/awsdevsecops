resource "aws_codebuild_project" "project" {
  name          = "${var.projectName}"
  description   = "${var.projectDesc}"
  build_timeout = "5" // Specify in Minutes
  service_role = "${var.serviceRole}"

  source {
    type            = "${var.srcType}" // Options Available: "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "BITBUCKET", "S3", "NO_SOURCE"
    location        = "${var.srcLocation}"
    buildspec       = "${var.buildSpecFilePath}"
    git_clone_depth = 1
    
    git_submodules_config {
      fetch_submodules = true
    }
  }

  artifacts {
    type = "${var.artifactType}"
  }

  environment {
    type                        = "${var.envType}"
    compute_type                = "${var.envComputeType}"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.cloudwatchLogGroupName}"
      stream_name = "${var.cloudwatchLogStreamName}"
    }
  }
}
resource "aws_codebuild_project" "sca_project" {
  name          = "sca-${var.projectName}"
  description   = "sca ${var.projectDesc}"
  build_timeout = "5" // Specify in Minutes
  service_role = "${var.serviceRole}"

  source {
    type            = "${var.srcType}" // Options Available: "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "BITBUCKET", "S3", "NO_SOURCE"
    location        = "${var.srcLocation}"
    buildspec       = "${var.scaBuildSpecFilePath}"
    git_clone_depth = 1
    
    git_submodules_config {
      fetch_submodules = true
    }
  }

  artifacts {
    type = "${var.artifactType}"
  }

  environment {
    type                        = "${var.envType}"
    compute_type                = "${var.envComputeType}"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.cloudwatchLogGroupName}"
      stream_name = "${var.cloudwatchLogStreamName}"
    }
  }
}
resource "aws_codebuild_project" "sast_project" {
  name          = "sast-${var.projectName}"
  description   = "sast ${var.projectDesc}"
  build_timeout = "5" // Specify in Minutes
  service_role = "${var.serviceRole}"

  source {
    type            = "${var.srcType}" // Options Available: "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "BITBUCKET", "S3", "NO_SOURCE"
    location        = "${var.srcLocation}"
    buildspec       = "${var.sastBuildSpecFilePath}"
    git_clone_depth = 1
    
    git_submodules_config {
      fetch_submodules = true
    }
  }

  artifacts {
    type = "${var.artifactType}"
  }

  environment {
    type                        = "${var.envType}"
    compute_type                = "${var.envComputeType}"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.cloudwatchLogGroupName}"
      stream_name = "${var.cloudwatchLogStreamName}"
    }
  }
}
resource "aws_codebuild_project" "dast_project" {
  name          = "dast-${var.projectName}"
  description   = "dast ${var.projectDesc}"
  build_timeout = "5" // Specify in Minutes
  service_role = "${var.serviceRole}"

  source {
    type            = "${var.srcType}" // Options Available: "CODECOMMIT", "CODEPIPELINE", "GITHUB", "GITHUB_ENTERPRISE", "BITBUCKET", "S3", "NO_SOURCE"
    location        = "${var.srcLocation}"
    buildspec       = "${var.dastBuildSpecFilePath}"
    git_clone_depth = 1
    
    git_submodules_config {
      fetch_submodules = true
    }
  }

  artifacts {
    type = "${var.artifactType}"
  }

  environment {
    type                        = "${var.envType}"
    compute_type                = "${var.envComputeType}"
    image                       = "aws/codebuild/standard:7.0"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "${var.cloudwatchLogGroupName}"
      stream_name = "${var.cloudwatchLogStreamName}"
    }
  }
}