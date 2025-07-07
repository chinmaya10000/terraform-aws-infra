resource "aws_iam_role" "ssm_ec2_role" {
  name = "${var.env}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "${var.env}-ssm-policy-attachment"
  roles      = [aws_iam_role.ssm_ec2_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.env}-ssm-instance-profile"
  role = aws_iam_role.ssm_ec2_role.name
}