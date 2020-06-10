provider "aws" {
  region  = "ap-south-1"
  profile = "prachi"
}

resource "aws_key_pair" "task1-key" {
  key_name   = "task1-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVdmxLWUskaWuvwZCp52795oi+qvK4qry6ijxYHvFwbipvCRwo4BuoGmVcX/MmiRUyBFvySK0N8YytKCn8NkTMDw37ULJlSzzeQNxWtFdrbpxI5zBdskXY07BKMhDWgDAZHHk4+1BdtqTLBKkHUU1HAR5iDuNuCS52mfkGYAStN95ho/UzIhZLVxXA76oh1H2hV6vrHhpGquZpNxJq0IusSAa58quAaUyRCFpscEcehzZvryVdd2tHQnJ6kYMNPKGCLeLrrl5mchdzYCZoh6E/ern8/VOT6V154xS91B3DrEnIPCENWd8ZawzW28Z1d8ELfFoTSyc6DelErq8fryZB root@localhost.localdomain"
}


resource "aws_security_group" "task1-sg" {
  name        = "task1-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-b4a2bfdc"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task1-sg"
  }
}


resource "aws_instance" "task1-instance" {
  ami           = "ami-0447a12f28fddb066"
  instance_type = "t2.micro"
  key_name      = "task1-key"
  security_groups = [ "task1-sg" ]
  user_data = <<-EOF
                #! /bin/bash
                sudo yum install httpd -y
                sudo systemctl start httpd
                sudo systemctl enable httpd
                sudo yum install git -y


  EOF

  tags = {
    Name = "task1 instance"
  }

}

resource "aws_ebs_volume" "task1-ebs" {
  availability_zone = "ap-south-1a"
  size              = 1

  tags = {
    Name = "task1-ebs"
  }
}

resource "aws_volume_attachment" "task1-attach" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.task1-ebs.id
  instance_id = aws_instance.task1-instance.id
}
