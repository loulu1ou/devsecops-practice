# Allow EC2 to use assumerole policy
data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        actions         = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

# IAM route
resource "aws_iam_role" "ec2_ssm_role" {
    name                = "sec-lab-ec2-ssm-role"
    assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role.json
}

# bind SSM policy (least privilege)
resource "aws_iam_role_policy_attachment" "ssm_policy" {
    role                = aws_iam_role.ec2_ssm_role.name
    policy_arn          = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile - For EC2 to mount the role
resource "aws_iam_instance_profile" "ec2_profile" {
    name = "sec-lab-ec2-instance-profile"
    role = aws_iam_role.ec2_ssm_role.name
}