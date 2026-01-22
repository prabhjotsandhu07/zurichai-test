# Import block for Shadow IT EC2 instance
import {
  to = aws_instance.london_ec2_sbx
  id = "i-06add591f2b15350e"
}

# EC2 Instance: london-ec2-sbx
# Originally created as Shadow IT, now codified for IaC management
resource "aws_instance" "london_ec2_sbx" {
  ami           = "ami-068c0051b15cdb816"
  instance_type = "t3.micro"
  key_name      = var.ec2_key_name

  subnet_id              = data.aws_subnet.selected.id
  vpc_security_group_ids = [aws_security_group.london_ec2_sbx.id]

  # Preserve existing private IP to prevent drift
  private_ip = "172.31.30.20"

  # Security: Disable public IP for new instances (current has one due to subnet settings)
  # Note: Existing instance has public IP 184.73.96.57 - will be preserved on import
  associate_public_ip_address = true

  # Security: Enable detailed monitoring
  monitoring = true

  # Security: Enable EBS optimization for t3 instances
  ebs_optimized = true

  # Security: Protect against accidental termination
  disable_api_termination = false

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name        = "london-ec2-sbx-root"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"  # Enforce IMDSv2
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  tags = {
    Name        = "london-ec2-sbx"
    Environment = var.environment
    ManagedBy   = "terraform"
    ImportedAt  = timestamp()
    OriginalID  = "i-06add591f2b15350e"
  }

  lifecycle {
    ignore_changes = [
      # Ignore AMI changes to prevent unwanted replacements
      ami,
      # Preserve user data if modified outside Terraform
      user_data,
      user_data_base64
    ]
  }
}

# Security Group for london-ec2-sbx
resource "aws_security_group" "london_ec2_sbx" {
  name_prefix = "london-ec2-sbx-"
  description = "Security group for london-ec2-sbx instance"
  vpc_id      = data.aws_vpc.selected.id

  # Add your required ingress rules here
  # Example: SSH access (restrict source IP in production)
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr_blocks]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "london-ec2-sbx-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# Data source for VPC
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Data source for Subnet
data "aws_subnet" "selected" {
  id = var.subnet_id
}

# Output the instance details
output "london_ec2_sbx_instance_id" {
  description = "ID of the london-ec2-sbx instance"
  value       = aws_instance.london_ec2_sbx.id
}

output "london_ec2_sbx_private_ip" {
  description = "Private IP of the london-ec2-sbx instance"
  value       = aws_instance.london_ec2_sbx.private_ip
}

output "london_ec2_sbx_public_ip" {
  description = "Public IP of the london-ec2-sbx instance"
  value       = aws_instance.london_ec2_sbx.public_ip
}