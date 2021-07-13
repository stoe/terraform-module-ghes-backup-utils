resource "aws_security_group" "security_group" {
  name        = format("%s-sg", var.name)
  description = "GitHub Enterprise Server Backup Utils Network Ports"

  vpc_id = var.vpc_id

  tags = merge(
    map("Name", format("%s-sg", var.name)),
    var.tags
  )

  # outbound -----------------------------------------------------------------------------------------------------------
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "(internet) access: all"
  }

  # inbound ------------------------------------------------------------------------------------------------------------
  # Administrative ports
  ingress {
    from_port   = 122
    to_port     = 122
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH: Shell access for your GitHub Enterprise Server instance. Required to be open to incoming connections from all other nodes in a High Availability configuration. The default SSH port (22) is dedicated to Git and SSH application network traffic."
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "VPN: Secure replication network tunnel in High Availability configuration. Required to be open to all other nodes in the configuration."
  }

  # Application ports for end users
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH: Access to Git over SSH. Supports clone, fetch, and push operations to public and private repositories."
  }

  ingress {
    from_port   = 9418
    to_port     = 9418
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Git: Git protocol port supports clone and fetch operations to public repositories with unencrypted network communication."
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["379101102735"] # Debian

  # see: https://github.com/github/backup-utils/blob/master/Dockerfile
  name_regex = "^debian-stretch-hvm-x86_64-.*"

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "key_pair" {
  public_key = file(var.public_key_path)
  key_name   = "${var.name}-key"
}

resource "aws_instance" "backup_utils" {
  ami                    = data.aws_ami.ami.image_id
  instance_type          = var.backup_utils_instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  availability_zone      = var.backup_utils_az
  key_name               = aws_key_pair.key_pair.key_name
  source_dest_check      = false

  root_block_device {
    volume_size           = var.backup_utils_volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  tags = merge(
    map("Name", var.name),
    var.tags
  )

  volume_tags = merge(
    map("Name", var.name),
    var.tags
  )
}

resource "aws_eip" "backup_utils_eip" {
  instance = aws_instance.backup_utils.id
  vpc      = true

  tags = merge(
    map("Name", format("%s-eip", var.name)),
    var.tags
  )
}
