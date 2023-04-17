
# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {

}


resource "aws_iam_policy" "policy_publish_sns" {

}


resource "aws_iam_policy" "policy_invoke_lambda" {

}


// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {

}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {

}



// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {

}
