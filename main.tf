provider "aws" {
  access_key = "$access_key"
  secret_key = "$secret_key"
  region     = "us-east-2"
}

resource "aws_security_group" "allow-ssh" {
  name        = "terraformsg"
  description = "terraformsg"

  ingress {
    from_port   = 22
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2-web" {
  ami                    = "ami-0443305dabd4be2bc"
  instance_type          = "t2.micro"
  key_name               = "assignment"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  provisioner "remote-exec" {
    inline = [
      "sudo yum install docker -y",
      "sudo curl -sfL https://get.k3s.io | sh -s",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    host        = "${aws_instance.ec2-web.public_ip}"
    private_key = "${file("assignment.pem")}"
  }
}

resource "aws_instance" "ec2-node" {
  ami                    = "ami-0443305dabd4be2bc"
  instance_type          = "t2.micro"
  key_name               = "assignment"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
}

output "list-ipadress" {
  description = "public IP adress"
  value       = "${aws_instance.ec2-web.public_ip}"
}

output "list-private-ip" {
  description = "private IP"
  value       = "${aws_instance.ec2-web.private_ip}"
}

output "list-key-pair" {
  description = "To list the key pair"
  value       = "${aws_instance.ec2-web.key_name}"
}

output "list-ipadress-node" {
  description = "public IP adress"
  value       = "${aws_instance.ec2-node.public_ip}"
}
