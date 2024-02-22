resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.this.id]
  user_data = <<EOF
              #!/bin/bash
              yum udpate -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello this is terragrunt</h1>" > /var/www/html/index.html
              EOF

  
  tags = {
    Name = "${var.env}-instance"
  }
}


output "public_ip" {
  value = aws_instance.this.public_ip
}