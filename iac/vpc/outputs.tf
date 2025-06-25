output "ec2_public_ip" {
  value = aws_instance.news_instance.public_ip
}