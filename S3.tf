# Shaping up my S3 bucket to contain my artifacts for codbuild and the configuration for remote access

resource "aws_s3_bucket" "my_codepipeline_artifacts" {
  bucket = "my-tf-artifacts-test-bucket"

}
resource "aws_s3_bucket_ownership_controls" "Owncontrol" {
  bucket = aws_s3_bucket.my_codepipeline_artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.Owncontrol]

  bucket = aws_s3_bucket.my_codepipeline_artifacts.id
  acl    = "private"
}