resource "aws_vpc" "main" {
    cidr_block           = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true 

    tags = {
        Name = "sec-lab-vpc"
    }
}

# Internet Gateway (out)
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "sec-lab-igw"
    }
}

# public subnet - for Web/EC2
resource "aws_subnet" "public" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "${var.aws_region}a"
    map_public_ip_on_launch = true # EC2 auto get Public IP

    tags = {
        Name = "sec-lab-public-subnet"
        Tier = "Public"
    }
}

# Private subnet - for database
resource "aws_subnet" "private" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.2.0/24"
    availability_zone       = "${var.aws_region}a"

    tags = {
        Name = "sec-lab-private-subnet"
        Tier = "Private"
    }
}

# Route Table - Public traffic route to igw
resource "aws_route_table" "public" {
    vpc_id                  = aws_vpc.main.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "sec-lab-public-rt"
    }
}

# Associate with Public Route table to Public subnet
resource "aws_route_table_association" "public" {
    subnet_id       = aws_subnet.public.id
    route_table_id  = aws_route_table.public.id
}

