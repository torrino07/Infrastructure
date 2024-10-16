resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.sg_private]
  key_name               = var.environment
  iam_instance_profile   = var.s3_profile

  tags = {
    Name        = "${var.environment}-trading-server"
    Environment = var.environment
  }
  
  # Create the EC2 instance using the generated key pair

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo mkdir -p /home/ubuntu/downloads",
  #     "sudo chown ubuntu:ubuntu /home/ubuntu/downloads",
  #     "echo 'USERNAME=${var.username_dev}' | sudo tee -a /etc/environment",
  #     "echo 'PASSWORD=${var.password_dev}' | sudo tee -a /etc/environment",
  #     "echo 'HOST=${var.db_endpoint_dev}' | sudo tee -a /etc/environment",
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = var.private_key_pem_dev
  #     host        = self.public_ip
  #   }
  # }
}
