# aws-ci-cd-pipeline-with-terraform

Prerequisites:
- github account
- AWS account
- AWS CLI
- terraform
- dockerhub account

Provisionning a user with sufficient access for codepipeline and codebuild

configure the AWS cLI with the user profile

access to the AWS SECRETS MANAGER service to grant Aws the right to use our docker hub account

create a Codestar connection to link your AWS account to your github for events

create a S3 bucket to receive the terraform state as backend . the bucket has to be configure to give remote access . i add a policy enabling it 


create a variable.tf, terraform.tfvars file to stock the variable name for the dockerhub secrets , the Codestar connection and the S3 bucket for terraform.tfstate 

create a state.tf file to configure the S3 bucket as the terraform state backend so terraform can record into it its managerd resources registry.

create an iam_role.tf so by definin a role , an access policy and access poliy attachment to each of codebuild and code pipeline service to work freely.

create a S3.tf to procisionne the private bucket that will store the build artifacts

create a provider.tf and configure it

create a buildspec folder within 2 buildspec.yaml files for each tep of the build process (plan and apply in our case as template for actions)

create a pipeline.tf with two codebuild projects and a pipeline


