resource "aws_codepipeline" "codepipeline" {
  name     = "${var.pipelineName}"
  role_arn = "${var.serviceRole}"

  artifact_store {
    location = "${var.artifactLocation}"
    type     = "S3"

    encryption_key {
      id   = "${var.encryptionKeyId}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = "${var.repoName}"
        BranchName = "${var.branchName}"
      }
    }
  }

/* Lambda Image Deployment*/
######################## S T A R T #########################

  /* stage {
    name = "LambdaCodeBuild"
    action {
      name             = "LambdaCodeBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      namespace        = "BuildVariables"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      
      configuration = {
        ProjectName = "${var.buildProjectName}"
      }
    }
  }
  
  stage {
    name = "LambdaDeployment"
    action {
      name            = "LambdaDeployment"
      category        = "Invoke"
      owner           = "AWS"
      provider        = "Lambda"
      version         = "1"
      namespace       = "DeployVariables"
      input_artifacts = ["BuildArtifact"]
      

      configuration = {
        FunctionName = "MyLambdaFunc"
      }
    }
  } */
######################## E N D #########################

/* ECS Blue/Green Deployment*/
######################## S T A R T #########################
  stage {
    name = "ECSImageBuild"
    action {
      name             = "ECSImageBuild"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      namespace        = "BuildVariables"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      
      configuration = {
        ProjectName = "${var.buildProjectName}"
      }
    }
  }

  stage {
    name = "Software_Composition_Analysis-SCA"
    action {
      name             = "OWASP_Dependency_Check"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      namespace        = "BuildVariables"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      
      configuration = {
        ProjectName = "${var.buildProjectName}"
      }
    }
  }

  stage {
    name = "Static_Application_Security_Testing-SAST"
    action {
      name             = "OWASP_Dependency_Check"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      namespace        = "BuildVariables"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      
      configuration = {
        ProjectName = "${var.buildProjectName}"
      }
    }
  }

  stage {
    name = "Dynamic_Application_Security_Testing-DAST"
    action {
      name             = "OWASP_ZAP_Test"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      namespace        = "BuildVariables"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      
      configuration = {
        ProjectName = "${var.buildProjectName}"
      }
    }
  }

  stage {
    name = "ECSBlueGreenDeployment"
    action {
      name            = "ECSBlueGreenDeployment"
      category        = "Deploy" // Other available Options "Invoke"
      owner           = "AWS"
      provider        = "CodeDeployToECS" // Other Available Options "Lambda"
      version         = "1"
      namespace       = "DeployVariables"
      input_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      

      configuration = {
        ApplicationName = "${var.appName}"
        DeploymentGroupName = "${var.deploymentGroupName}"
        TaskDefinitionTemplateArtifact = "${var.defArtifact}"
        TaskDefinitionTemplatePath = "${var.taskDefJSON}"
        AppSpecTemplateArtifact = "${var.defArtifact}"
        AppSpecTemplatePath = "${var.appSpecJSON}"
        Image1ArtifactName = "${var.imgArtifact}"
        Image1ContainerName = "${var.imgContainerName}"
      }
    }
  }
}
######################## E N D #########################