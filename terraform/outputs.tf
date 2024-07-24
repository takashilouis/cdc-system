output "public_ip" {
  value = {
    for name,instance in aws_instance.crawler: 
    name => instance.public_ip
  }
}