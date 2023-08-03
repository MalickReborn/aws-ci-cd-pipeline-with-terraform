/* In the case you have not already created a S3 bucket and wa,t to provision from it from here 

S3 Bucket on Which we will add policy
resource "aws_s3_bucket" "this"{
  bucket = var.terraform_bucket
} 
resource "aws_s3_bucket_policy" "full_access" {
  bucket = var.terraform_bucket.id
  policy = <<EOF
        {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::740336226278:user/devops"
            },
            "Action": [
                "s3:ListBucket",
                "s3:GetObject",
                "s3:PutObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::arn:aws:s3:::my-pipeline-bucket",
                "arn:aws:s3:::arn:aws:s3:::my-pipeline-bucket/*"
            ]
            }
        ]
        }
        EOF
        } 
*/

# configuration to use our available S3 bucket as a backend store
terraform {
    backend "s3" {
      bucket = "my-aws-cicd-piepline-bucket"
      encrypt = true
      key = "terraform.tfstate"
      region = "us-east-1"
}
}