# Compute module - main.tf

# Security group for instances
resource "aws_security_group" "instance_sg" {
  name        = "${var.environment}-instance-sg"
  description = "Security group for instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.environment}-instance-sg"
    Environment = var.environment
  }
}

# EC2 instances
resource "aws_instance" "app_servers" {
  count                  = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = var.key_name

  tags = {
    Name        = "${var.environment}-app-server-${count.index + 1}"
    Environment = var.environment
  }
}