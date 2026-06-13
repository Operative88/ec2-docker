output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "ssh" {
  value = "ssh ubuntu@${aws_instance.web.public_ip}"
}
