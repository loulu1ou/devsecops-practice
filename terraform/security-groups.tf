resource "aws_security_group" "juice_shop_us2" {
    name           = "sec-lab-juice-shop-us2"
    description    = "Allow inbound web traffic to Juice Shop"
    vpc_id         = aws_vpc.main.id

    # open port 3000 to public 
    ingress {
        description = "juice shop web port"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Egress - Allow all traffic e.g download docker, pull image, os update
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    tags = {
        Name = "sec-lab-juice-shop-us2"
    }
}