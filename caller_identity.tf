# This allows us to retrieve the ID of the AWS account being used
data "aws_caller_identity" "current" {
}
