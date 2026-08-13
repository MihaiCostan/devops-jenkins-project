output "ec2_public_ip" {
  value       = aws_instance.fastapi_server.public_ip
  description = "IP address for access FastAPI app"
}

output "app_url" {
    description = "URL for access FastAPI app"
    value = "http://${aws_instance.fastapi_server.public_ip}:8000"
}
