resource "aws_codebuild_project" "tf_plan" {
  name           = "test_cicd_plan"
  description    = "Plan stage for terraform"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  /*
  cache {
    type  = "S3"
    location = aws_s3_bucket.my_codepipeline_artifacts.id
  }
   */

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.5"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
      credential = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = file("buildspec/plan_buildspec.yaml")
    
  }

}

resource "aws_codebuild_project" "tf_apply" {
  name           = "test_cicd_apply"
  description    = "Apply stage for terraform"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  /*
  cache {
    type  = "S3"
    location = aws_s3_bucket.my_codepipeline_artifacts.id
  }
   */

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.5"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
      credential = var.dockerhub_credentials
      credential_provider = "SECRETS_MANAGER"
    }
  }

  source {
    type            = "CODEPIPELINE"
    buildspec = file("buildspec/apply_buildspec.yaml")
    
  }

}

resource "aws_codepipeline" "cicd_pipeline" {

    name     = "cicd_pipeline"
    role_arn = aws_iam_role.codepipeline_role.arn

    artifact_store {
        location = aws_s3_bucket.my_codepipeline_artifacts.bucket
        type     = "S3"

    }

    stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["tf-code"]

      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "aws-ci-cd-pipeline-with-terraform"
        BranchName       = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Plan"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "Codebuild"
      output_artifacts = ["tf-code"]
      version          = "1"

      configuration = {
        ProjectName = "test_cicd_plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "Codebuild"
      output_artifacts = ["tf-code"]
      version          = "1"

      configuration = {
        ProjectName = "test_cicd_plan"
      }
    }
  }

  
}