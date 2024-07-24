resource "aws_instance" "crawler" {
  for_each = toset(local.students)

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  key_name      = "test"

  # /var/log/cloud-init-output.log
  user_data     = data.cloudinit_config.config.rendered

  vpc_security_group_ids = [
    aws_security_group.crawler.id
  ]

  root_block_device {
    volume_size = 30
  }

  lifecycle {
    ignore_changes = [
      ami
    ]
  }

  tags = {
    Name = "Crawler-${each.value}"
  }
}
