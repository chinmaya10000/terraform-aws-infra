# resource "aws_security_group" "web" {
#   name   = "${local.env}-web-sg"
#   vpc_id = aws_vpc.main.id

#   dynamic "ingress" {
#     for_each = local.web_ingress_rules

#     content {
#       from_port   = ingress.key
#       to_port     = ingress.key
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }
#   dynamic "egress" {
#     for_each = local.web_egress_rules

#     content {
#       from_port   = egress.value.from_port
#       to_port     = egress.value.to_port
#       protocol    = egress.value.protocol
#       cidr_blocks = egress.value.cidr_blocks
#     }
#   }
# }

resource "aws_security_group" "web" {
  name   = "${local.env}-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.207.209.88/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_security_group" "alb_sg" {
#   name   = "${local.env}-alb-sg"
#   vpc_id = aws_vpc.main.id

#   dynamic "ingress" {
#     for_each = local.alb_ingress_rules

#     content {
#       from_port   = ingress.key
#       to_port     = ingress.key
#       protocol    = "tcp"
#       cidr_blocks = [ingress.value]
#     }
#   }

#   dynamic "egress" {
#     for_each = local.alb_egress_rules

#     content {
#       from_port   = egress.value.from_port
#       to_port     = egress.value.to_port
#       protocol    = egress.value.protocol
#       cidr_blocks = egress.value.cidr_blocks
#     }
#   }

#   tags = {
#     Name = "${local.env}-alb-sg"
#   }
# }

resource "aws_security_group" "alb_sg" {
  name   = "${local.env}-alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
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
    Name = "${local.env}-alb-sg"
  }
}