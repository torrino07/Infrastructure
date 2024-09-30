resource "aws_instance" "trading_server_dev" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = var.key_name_dev
  subnet_id              = var.dev_public_subnet
  vpc_security_group_ids = [var.sg_public, var.sg_private]

  associate_public_ip_address = true
  iam_instance_profile        = var.s3_profile

  tags = {
    Name = "Trading-Server-dev"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/downloads",
      "sudo chown ubuntu:ubuntu /home/ubuntu/downloads",
      "echo 'USERNAME=${var.username_dev}' | sudo tee -a /etc/environment",
      "echo 'PASSWORD=${var.password_dev}' | sudo tee -a /etc/environment",
      "echo 'HOST=${var.db_endpoint_dev}' | sudo tee -a /etc/environment",
      "echo 'PORT=5432' | sudo tee -a /etc/environment",
      "echo 'ENV=dev' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_IP=${self.public_ip}' | sudo tee -a /etc/environment",
      "echo 'PRIVATE_IP=${self.private_ip}' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_DNS=${self.public_dns}' | sudo tee -a /etc/environment",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.private_key_pem_dev
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "trading_server_test" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = var.key_name_test
  subnet_id              = var.test_public_subnet
  vpc_security_group_ids = [var.sg_public, var.sg_private]

  associate_public_ip_address = true
  iam_instance_profile        = var.s3_profile

  tags = {
    Name = "Trading-Server-test"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/downloads",
      "sudo chown ubuntu:ubuntu /home/ubuntu/downloads",
      "echo 'USERNAME=${var.username_test}' | sudo tee -a /etc/environment",
      "echo 'PASSWORD=${var.password_test}' | sudo tee -a /etc/environment",
      "echo 'HOST=${var.db_endpoint_test}' | sudo tee -a /etc/environment",
      "echo 'PORT=5432' | sudo tee -a /etc/environment",
      "echo 'ENV=test' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_IP=${self.public_ip}' | sudo tee -a /etc/environment",
      "echo 'PRIVATE_IP=${self.private_ip}' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_DNS=${self.public_dns}' | sudo tee -a /etc/environment",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.private_key_pem_test
      host        = self.public_ip
    }
  }
}

resource "aws_instance" "trading_server_prod" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = var.key_name_prod
  subnet_id              = var.prod_public_subnet
  vpc_security_group_ids = [var.sg_public, var.sg_private]

  associate_public_ip_address = true
  iam_instance_profile        = var.s3_profile

  tags = {
    Name = "Trading-Server-prod"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /home/ubuntu/downloads",
      "sudo chown ubuntu:ubuntu /home/ubuntu/downloads",
      "echo 'USERNAME=${var.username_prod}' | sudo tee -a /etc/environment",
      "echo 'PASSWORD=${var.password_prod}' | sudo tee -a /etc/environment",
      "echo 'HOST=${var.db_endpoint_prod}' | sudo tee -a /etc/environment",
      "echo 'PORT=5432' | sudo tee -a /etc/environment",
      "echo 'ENV=prod' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_IP=${self.public_ip}' | sudo tee -a /etc/environment",
      "echo 'PRIVATE_IP=${self.private_ip}' | sudo tee -a /etc/environment",
      "echo 'PUBLIC_DNS=${self.public_dns}' | sudo tee -a /etc/environment",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = var.private_key_pem_prod
      host        = self.public_ip
    }
  }
}