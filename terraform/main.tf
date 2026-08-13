#AWS Provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  
}

provider "aws" {
    region = var.aws_region
}

#System image (AMI)
data "aws_ami" "ubuntu" {
    most_recent = "true"
    
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    owners = ["099720109477"]
}

resource "aws_iam_role" "ssm_role" {
    name = "ec2-ssm-execution-role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = { Service = "ec2.amazonaws.com"}
        }]
    })
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
    role = aws_iam_role.ssm_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
    name = "ec2-ssm-instance-profile"
    role = aws_iam_role.ssm_role.name
}

#AWS Firewall (open ports on 22 (SSH), 8000 (FastAPI), 80(HTTP))
resource "aws_security_group" "fastapi_sg" {
    name = "fastapi-app-sg"
    description = "Permits access on port 8000, 80 & 22"
    
    ingress {
        description = "FastAPI App Port"
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #accessible anywhere on the internet
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] #the server can access anything on the internet
    }
}

#EC2 instance + Bootstrap script (user_data)
resource "aws_instance" "fastapi_server" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instace_type
    vpc_security_group_ids = [aws_security_group.fastapi_sg.id]
    iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
    key_name = "ec2_jenkins_key"

    #User Data: automate docker install & container run
    user_data = <<-EOF
    #!/bin/bash
    set -e
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker

    docker pull ${var.docker_image}
    docker run -d --name app -p 8000:8000 ${var.docker_image}
    EOF

    tags = {
        Name = "fastapi-devops-server"
    }
}