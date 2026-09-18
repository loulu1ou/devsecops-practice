output "juice_shop_public_ip" {
  description = "Public IP of Juice Shop EC2"
  value       = aws_instance.juice_shop.public_ip
}

output "juice_shop_url" {
  description = "URL to access Juice Shop"
  value       = "http://${aws_instance.juice_shop.public_ip}:3000"
}