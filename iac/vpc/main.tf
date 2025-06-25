provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "news_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "news-network"
  }
}

resource "aws_subnet" "news_subnet" {
  vpc_id                  = aws_vpc.news_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "news-subnet"
  }
}

resource "aws_internet_gateway" "news_igw" {
  vpc_id = aws_vpc.news_vpc.id
  tags = {
    Name = "news-igw"
  }
}

resource "aws_route_table" "news_rt" {
  vpc_id = aws_vpc.news_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.news_igw.id
  }
  tags = {
    Name = "news-route-table"
  }
}

resource "aws_route_table_association" "news_rta" {
  subnet_id      = aws_subnet.news_subnet.id
  route_table_id = aws_route_table.news_rt.id
}

resource "aws_security_group" "news_sg" {
  name        = "news-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.news_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  description = "Django"
  from_port   = 8000
  to_port     = 8000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
 }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "news-sg"
  }
}

resource "aws_instance" "news_instance" {
  ami                         = "ami-0c2b8ca1dad447f8a" # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.news_subnet.id
  vpc_security_group_ids      = [aws_security_group.news_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  #user_data = file("userdata.sh")

  tags = {
    Name = "news-ec2"
  }
}