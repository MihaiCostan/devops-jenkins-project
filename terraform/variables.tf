variable "aws_region" {
    description = "AWS Region where the resources are created (EC2 in this case)"
    type = string
    default = "eu-central-1"
}

variable "instace_type" {
    description = "The instance type EC2 (t3.micro)"
    type = string
    default = "t3.micro"
}

variable "docker_image" {
    description = "The Docker image published on DockerHub"
    type = string
    default = "mihai2312/devops_python_project"
}