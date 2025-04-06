# IAM role and policy for EC2 instances to access S3.

resource "aws_iam_role" "role-for-s3-will-attach-to-ec2" {
  name= "roleForS3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "policy-for-s3"  {
  name = "policy-for-s3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
     {
       Action = [
         "s3:GetObject",
         "s3:ListBucket"
       ]
       Effect = "Allow"
       Resource = "*"
     }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role = aws_iam_role.role-for-s3-will-attach-to-ec2.name
  policy_arn = aws_iam_policy.policy-for-s3.arn
}

# Creates an instance profile that associates the IAM role with EC2 instances.
resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.role-for-s3-will-attach-to-ec2.name
}

