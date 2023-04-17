##################### typescript build sample
resource "aws_lambda_function" "typesctipt-sample" {

}

resource "aws_s3_bucket" "lambda_assets" {}
resource "aws_s3_bucket_acl" "lambda_assets" {

}
resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_assets" {

}
resource "aws_s3_bucket_public_access_block" "lambda_assets" {

}

data "aws_s3_object" "package" {

}

resource "null_resource" "lambda_build" {

}

data "aws_s3_object" "package_hash" {

}
