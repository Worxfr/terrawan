


resource "aws_vpc" "exchvpc" {
  ipv4_ipam_pool_id   = var.pool_map[var.region]
  ipv4_netmask_length = 24
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.name}-vpc-exch"
  }
  //depends_on = [ var.poolchild ]
}

resource "aws_vpc" "affvpc" {
  cidr_block = "${var.affcidr}"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "${var.name}-vpc-aff"
  }

  //depends_on = [ var.poolchild ]
}

resource "aws_internet_gateway" "IGWAff" {
  vpc_id = aws_vpc.affvpc.id

  tags = {
    Name = "${var.name}-aff-igw"
  }
}

resource "aws_subnet" "sub-exch" {
  cidr_block        =  cidrsubnet(aws_vpc.exchvpc.cidr_block, 4, 0)
  availability_zone  = data.aws_availability_zones.available.names[0]
  vpc_id            =  aws_vpc.exchvpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-exch"
  }
  depends_on = [ aws_vpc.exchvpc ]
}

# create vpc route table
resource "aws_route_table" "sub-exch-tgw-rt" {
  vpc_id =  aws_vpc.exchvpc.id
  tags = {
    Name = "${var.name}-sub-exch-tgw-rt"
  }
  depends_on = [ aws_vpc.exchvpc ]
}

# create vpc route table
resource "aws_route_table" "sub-aff-pub-rt" {
  vpc_id =  aws_vpc.affvpc.id
  tags = {
    Name = "${var.name}-sub-aff-pub-rt"
  }
  depends_on = [ aws_vpc.affvpc ]
}

resource "aws_subnet" "sub-exch-tgw" {
  cidr_block        =  cidrsubnet(aws_vpc.exchvpc.cidr_block, 4, 1)
  availability_zone  = data.aws_availability_zones.available.names[0]
  vpc_id            =  aws_vpc.exchvpc.id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name}-sub-exch-tgw"
  }
  depends_on = [ aws_vpc.exchvpc ]
}

resource "aws_subnet" "sub-aff" {
  cidr_block        =  cidrsubnet(aws_vpc.affvpc.cidr_block, 4, 0)
  availability_zone  = data.aws_availability_zones.available.names[0]
  vpc_id            =  aws_vpc.affvpc.id
  map_public_ip_on_launch = false
  
  tags = {
    Name = "${var.name}-sub-aff"
  }
  depends_on = [ aws_vpc.affvpc ]
}

resource "aws_subnet" "sub-aff-pub" {
  cidr_block        =  cidrsubnet(aws_vpc.affvpc.cidr_block, 4, 1)
  availability_zone  = data.aws_availability_zones.available.names[0]
  vpc_id            =  aws_vpc.affvpc.id
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.name}-sub-aff-pub"
  }

  depends_on = [ aws_vpc.affvpc ]
}

resource "aws_route_table_association" "sub-exch-tgw-rt-asso" {
  subnet_id      = aws_subnet.sub-exch-tgw.id
  route_table_id = aws_route_table.sub-exch-tgw-rt.id
}

resource "aws_route_table_association" "sub-aff-pub-rt-asso" {
  subnet_id      = aws_subnet.sub-aff-pub.id
  route_table_id = aws_route_table.sub-aff-pub-rt.id
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "nateip" {
    domain = "vpc"
    tags = {
        Name = "${var.name}-nat-eip"
    }
    depends_on = [ aws_internet_gateway.IGWAff ]
}

resource "aws_nat_gateway" "PrivateNatGW-exch" {
  allocation_id = aws_eip.nateip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.sub-aff-pub.id
  tags = {
    Name = "${var.name}-nat-gw-pub"
  }
  depends_on = [ aws_vpc.affvpc ]
}

resource "aws_nat_gateway" "PublicNatGW-AFF" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.sub-exch.id
  tags = {
    Name = "${var.name}-nat-gw-priv"
  }
  depends_on = [ aws_vpc.exchvpc ]
}

resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "Transit Gateway testing scenario with 4 VPCs, 2 subnets each"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  tags                            = {
    Name = "${var.name}-tgw"
  }
  depends_on = [ aws_vpc.exchvpc, aws_vpc.affvpc ]
}

/*resource "aws_ec2_transit_gateway_route_table" "tgw-rt" {
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"

  tags               = {
    Name = "${var.name}-tgw-rt"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}*/

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-1" {
  subnet_ids         = ["${aws_subnet.sub-aff.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"
  vpc_id             = "${aws_vpc.affvpc.id}"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags               = {
    Name             = "${var.name}-tgw-attch-vpc1"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-att-vpc-2" {
  subnet_ids         = ["${aws_subnet.sub-exch-tgw.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.tgw.id}"
  vpc_id             = "${aws_vpc.exchvpc.id}"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags               = {
    Name             = "${var.name}-tgw-attch-vpc1"
  }
  depends_on = [aws_ec2_transit_gateway.tgw]
}

# create a exch transit gateway route
resource "aws_ec2_transit_gateway_route" "tgw-route-1" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = "${aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-2.id}"
  transit_gateway_route_table_id = "${aws_ec2_transit_gateway.tgw.association_default_route_table_id}"
  depends_on = [ aws_ec2_transit_gateway_vpc_attachment.tgw-att-vpc-1 ]
}


resource "aws_route" "privSUb-default-vpcaff-to-exch-10" {
  route_table_id         = aws_vpc.affvpc.default_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
  depends_on             = [aws_vpc.affvpc, aws_ec2_transit_gateway.tgw]
}

resource "aws_route" "privSUb-default-vpcaff-to-exch-100" {
  route_table_id         = aws_vpc.affvpc.default_route_table_id
  destination_cidr_block = "100.64.0.0/20"
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
  depends_on             = [aws_vpc.affvpc, aws_ec2_transit_gateway.tgw]
}

resource "aws_route" "privSUb-default-vpcaff" {
  route_table_id         = aws_vpc.affvpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.PrivateNatGW-exch.id
  depends_on             = [aws_vpc.affvpc, aws_ec2_transit_gateway.tgw]
}

resource "aws_route" "pubSUb-default-vpcaff" {
  route_table_id         = aws_route_table.sub-aff-pub-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IGWAff.id
  depends_on             = [aws_vpc.affvpc, aws_internet_gateway.IGWAff]
}

resource "aws_route" "vpcexch-to-vpcaff" {
  route_table_id         = aws_vpc.exchvpc.default_route_table_id
  destination_cidr_block = var.affcidr
  transit_gateway_id     = "${aws_ec2_transit_gateway.tgw.id}"
  depends_on             = [aws_vpc.exchvpc, aws_ec2_transit_gateway.tgw]
}

resource "aws_route" "default-vpcexchtgw" {
  route_table_id         = aws_route_table.sub-exch-tgw-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.PublicNatGW-AFF.id
  depends_on             = [aws_vpc.affvpc, aws_ec2_transit_gateway.tgw, var.core_depends_on]
}




# Create a security group for the VPC endpoint
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "${var.name}-vpc-endpoint-sg"
  description = "Security group for VPC Endpoint"
  vpc_id      = aws_vpc.affvpc.id

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.affvpc.cidr_block]
  }

  tags = {
    Name = "${var.name}-vpc-endpoint-sg"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.affvpc.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.sub-aff.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id            = aws_vpc.affvpc.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.sub-aff.id
  ]
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id            = aws_vpc.affvpc.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true
  subnet_ids = [
    aws_subnet.sub-aff.id
  ]
}

# Create a security group for the EC2 instance
resource "aws_security_group" "web_sg" {
  name        = "${var.name}-web-sg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.affvpc.id

  ingress {
    description = "HTTP from anywhere"
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
    Name = "${var.name}-web-sg"
  }
}

# Create an IAM role for EC2 instances to use with Session Manager
resource "aws_iam_role" "ssm_role" {
  name = "${var.name}-ssm-role"

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

  tags = {
    Name = "${var.name}-ssm-role"
  }
}

# Attach the AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ssm_role.name
}

# Create an instance profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.name}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

# Create an EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3a.micro"
  subnet_id     = aws_subnet.sub-aff.id

  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from $(hostname -f) in ${var.name}</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "${var.name}-web-server"
  }

  depends_on = [ aws_internet_gateway.IGWAff,aws_nat_gateway.PrivateNatGW-exch ]
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create a Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.sub-exch.id]

  enable_deletion_protection = false

  tags = {
    Name = "${var.name}-nlb"
  }
}

# Create a target group
resource "aws_lb_target_group" "tg" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.exchvpc.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

# Attach the EC2 instance to the target group
resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web_server.private_ip
  port             = 80
  availability_zone = data.aws_availability_zones.available.names[0]
}

# Create a listener for the NLB
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# attach the vpc to the Cloudwan corenetwork
resource "aws_networkmanager_vpc_attachment" "exchvpsegmentcattach" {
  core_network_id = var.core_network_id
  subnet_arns     = [aws_subnet.sub-exch.arn]
  vpc_arn         = aws_vpc.exchvpc.arn
  
  tags = {
    Name = "${var.name}-exchvpc",
    CWAttach = var.segment
  }
  depends_on = [ aws_subnet.sub-exch, var.core_depends_on ]
}

resource "aws_networkmanager_attachment_accepter" "test" {
  attachment_id   = aws_networkmanager_vpc_attachment.exchvpsegmentcattach.id
  attachment_type = aws_networkmanager_vpc_attachment.exchvpsegmentcattach.attachment_type
  depends_on = [ aws_networkmanager_vpc_attachment.exchvpsegmentcattach ]
}

# Default to Cloudwan
resource "aws_route" "default-vpcexch" {
  route_table_id         = aws_vpc.exchvpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  core_network_arn = var.core_network_arn
  depends_on             = [aws_vpc.exchvpc, aws_networkmanager_attachment_accepter.test]
}