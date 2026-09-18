data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "juice_shop" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.micro" 
  subnet_id            = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.juice_shop_us2.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Force IMDSv2 - Prevent SSRF
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Token (IMDSv2)
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              apt-get update -y
              apt-get install -y ca-certificates curl gnupg lsb-release
              
              mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
              
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
              
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io
              
              systemctl start docker
              systemctl enable docker
              
              docker run -d \
                --name juice-shop \
                --restart always \
                -p 3000:3000 \
                -e NODE_ENV=unsafe \
                --memory="512m" \
                --cpus="0.5" \
                --cap-drop=ALL \
                bkimminich/juice-shop:latest
              EOF

  tags = {
    Name = "sec-lab-juice-shop-host"
  }
}