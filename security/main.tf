resource "aws_security_group" "security_group" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}

resource "aws_security_group_rule" "ingress_rule" {
  cidr_blocks       = var.cidr_blocks
  from_port         = var.ingress_from_port
  protocol          = "tcp"
  security_group_id = aws_security_group.security_group.id
  to_port           = var.ingress_to_port
  type              = "ingress"
}



