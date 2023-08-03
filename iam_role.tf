
# An i am role to grant access fo action to codepipeline service 

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "tf_cicd_pipeline_policies" {
  statement {
    sid = ""
    actions = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect = "Allow"
  }
  statement {
    sid = ""
    actions = ["cloudwatch:*", "s3:*", "codebuild:*",]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf_cicd_pipeline_policy" {
  name = "tf_cicd_pipeline_policy"
  path = "/"
  description = "Pipeline policy"
  policy = data.aws_iam_policy_document.tf_cicd_pipeline_policies.json
  
}
resource "aws_iam_policy_attachment" "tf_cicd_pipeline_policy_attachment" {
  policy_arn = aws_iam_policy.tf_cicd_pipeline_policy.arn
  role = aws_iam_role.codepipeline_role.id
}


# An i am role to grant access fo action to codebuild service 
resource "aws_iam_role" "codebuild" {
  name = "${var.application_name}-codebuild"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "tf_cicd_build_policies" {
  
  statement {
    sid = ""
    actions = ["logs:*", "s3:*", "codebuild:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_policy" "tf_cicd_build_policy" {
  name = "tf_cicd_build_policy"
  path = "/"
  description = "Codebuild policy"
  policy = data.aws_iam_policy_document.tf_cicd_build_policies.json
  
}

resource "aws_iam_role_policy_attachment" "tf_cicd_codebuild_policy_attachment" {
  role       = aws_iam_role.codebuild.id
  policy_arn = aws_iam_policy.tf_cicd_build_policy.arn
}

resource "aws_iam_role_policy_attachment" "tf_cicd_codebuild_policy_attachment2" {
  role       = aws_iam_role.codebuild.id
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

