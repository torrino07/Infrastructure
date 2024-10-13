resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.sg_private]
  iam_instance_profile   = var.s3_profile

  tags = {
    Name        = "${var.environment}-trading-server"
    Environment = var.environment
  }
  
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mkdir -p /home/ubuntu/downloads",
  #     "sudo chown ubuntu:ubuntu /home/ubuntu/downloads",
  #     "echo 'USERNAME=${var.username_dev}' | sudo tee -a /etc/environment",
  #     "echo 'PASSWORD=${var.password_dev}' | sudo tee -a /etc/environment",
  #     "echo 'HOST=${var.db_endpoint_dev}' | sudo tee -a /etc/environment",
  #     "echo 'PORT=5432' | sudo tee -a /etc/environment",
  #     "echo 'ENV=dev' | sudo tee -a /etc/environment",
  #     "echo 'PUBLIC_IP=${self.public_ip}' | sudo tee -a /etc/environment",
  #     "echo 'PRIVATE_IP=${self.private_ip}' | sudo tee -a /etc/environment",
  #     "echo 'PUBLIC_DNS=${self.public_dns}' | sudo tee -a /etc/environment",
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = var.private_key_pem_dev
  #     host        = self.public_ip
  #   }
  # }
}
