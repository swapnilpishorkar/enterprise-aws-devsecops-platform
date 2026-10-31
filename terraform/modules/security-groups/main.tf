resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for public Application Load Balancer"
  vpc_id      = var.vpc_id


  tags = {
    Name = "${var.project_name}-alb-sg"
    Tier = "Public"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Security group for private application workloads"
  vpc_id      = var.vpc_id


  tags = {
    Name = "${var.project_name}-app-sg"
    Tier = "Private"
  }
}

# ALB: Allow public HTTP traffic
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  description       = "Allow public HTTP traffic"
}

# ALB: Allow public HTTPS traffic
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  description       = "Allow public HTTPS traffic"
}

# ALB: Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic"
}

# Application: Allow port 5000 only from ALB security group
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 5000
  to_port                      = 5000
  ip_protocol                  = "tcp"
  description                  = "Allow application traffic from ALB"
}

# Application: Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "app_all" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow outbound traffic"
}
