
// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "archive-power-of-number-lambda" {
  type        = "zip"
  output_path = "./power-of-number-lambda/archive.zip"
  source_file = "./power-of-number-lambda/index.js"
}

data "archive_file" "archive-random-number-generator-lambda" {
  type        = "zip"
  output_path = "./random-number-generator-lambda/archive.zip"
  source_file = "./random-number-generator-lambda/index.js"
}

// Create IAM role for AWS Lambda

resource "aws_iam_role" "iam_for_lambda" {
  name = "stepFunctionSampleLambdaIAM"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// Create AWS Lambda functions

resource "aws_lambda_function" "power-of-number-lambda" {
  filename         = "./power-of-number-lambda/archive.zip"
  function_name    = "step-functions-sample-power-of-number"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
}

resource "aws_lambda_function" "random-number-generator-lambda" {
  filename         = "./random-number-generator-lambda/archive.zip"
  function_name    = "step-functions-sample-random-number-generator"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs18.x"
}

##################### typescript build sample
resource "aws_lambda_function" "typesctipt-sample" {
  function_name    = "typescript-sample-helloworld"
  s3_bucket        = aws_s3_bucket.lambda_assets.bucket
  s3_key           = data.aws_s3_object.package.key
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "index.handler"
  source_code_hash = data.aws_s3_object.package_hash.body
  runtime          = "nodejs18.x"
  timeout          = "10"
}

resource "aws_s3_bucket" "lambda_assets" {}
resource "aws_s3_bucket_acl" "lambda_assets" {
  bucket = aws_s3_bucket.lambda_assets.bucket
  acl    = "private"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "lambda_assets" {
  bucket = aws_s3_bucket.lambda_assets.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "lambda_assets" {
  bucket = aws_s3_bucket.lambda_assets.bucket

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_s3_object" "package" {
  depends_on = [null_resource.lambda_build]

  bucket = aws_s3_bucket.lambda_assets.bucket
  key    = local.helloworld_function_package_s3_key 
}

resource "null_resource" "lambda_build" {
  depends_on = [aws_s3_bucket.lambda_assets]

  triggers = {
    code_diff = join("", [
      for file in fileset(local.helloworld_function_dir_local_path, "{*.ts, package*.json}")
      : filebase64("${local.helloworld_function_dir_local_path}/${file}")
    ])
  }

  provisioner "local-exec" {
    command = "cd ${local.helloworld_function_dir_local_path} && yarn install"
  }
  provisioner "local-exec" {
    command = "cd ${local.helloworld_function_dir_local_path} && yarn run build"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ${local.helloworld_function_package_local_path} s3://${aws_s3_bucket.lambda_assets.bucket}/${local.helloworld_function_package_s3_key}"
  }
  provisioner "local-exec" {
    command = "openssl dgst -sha256 -binary ${local.helloworld_function_package_local_path} | openssl enc -base64 | tr -d \"\n\" > ${local.helloworld_function_package_base64sha256_local_path}"
  }
  provisioner "local-exec" {
    command = "aws s3 cp ${local.helloworld_function_package_base64sha256_local_path} s3://${aws_s3_bucket.lambda_assets.bucket}/${local.helloworld_function_package_base64sha256_s3_key} --content-type \"text/plain\""
  }
}

data "aws_s3_object" "package_hash" {
  depends_on = [null_resource.lambda_build]

  bucket = aws_s3_bucket.lambda_assets.bucket
  key    = local.helloworld_function_package_base64sha256_s3_key
}
