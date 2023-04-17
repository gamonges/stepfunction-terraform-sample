
// Create archives for AWS Lambda functions which will be used for Step Function

data "archive_file" "archive-power-of-number-lambda" {
}

data "archive_file" "archive-random-number-generator-lambda" {
}

// Create IAM role for AWS Lambda

resource "aws_iam_role" "iam_for_lambda" {

}

// Create AWS Lambda functions

resource "aws_lambda_function" "power-of-number-lambda" {

}

resource "aws_lambda_function" "random-number-generator-lambda" {

}
