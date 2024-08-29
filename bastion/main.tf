resource "aws_instance" "bastion_host" {
  ami                       = var.ami_id
  instance_type             = "t3.medium"
  vpc_security_group_ids    = [var.bastion_host_sg_id]
  subnet_id                 = var.subnet_id
  iam_instance_profile      = aws_iam_instance_profile.bastion_instance_profile.name
  key_name                  = "adil-oregon-ed25519-key"
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install unzip -y
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
              unzip /tmp/awscliv2.zip
              sudo /tmp/aws/install
              curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
              chmod +x /tmp/kubectl
              sudo mv /tmp/kubectl /usr/bin/
              EOF

  tags                      = {
    Name    = "${var.cluster_name}-bastion"
    env     = "dev"
  }

  root_block_device {
    delete_on_termination   = true
    volume_size             = 10
    volume_type             = "gp2"
    tags                    = {
        Name    = "${var.cluster_name}-bastion-ebs"
        env     = "dev"
    }
  }
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "${var.cluster_name}-bastion-instance-profile"
  role = aws_iam_role.bastion_host_role.name
}

resource "aws_iam_role" "bastion_host_role" {
  name = "${var.cluster_name}-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_full_access" {
  name        = "EKSFullAccessPolicy"
  description = "Policy that grants full access to EKS for kubernetes client like kubectl."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "eks:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_access_policy" {
  policy_arn = aws_iam_policy.eks_full_access.arn
  role       = aws_iam_role.bastion_host_role.name
}