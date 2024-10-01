resource "aws_vpc" "vpc_custom" {
  cidr_block = var.cidr_value
}

resource "aws_subnet" "subnet1" {
  vpc_id = aws_vpc.vpc_custom.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "subnet2" {
  vpc_id = aws_vpc.vpc_custom.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "aws_ig" {
  vpc_id = aws_vpc.vpc_custom.id
}

resource "aws_route_table" "aws_rt" {
  vpc_id = aws_vpc.vpc_custom.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_ig.id
  }
}

resource "aws_route_table_association" "aws_rta1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.aws_rt.id
}

resource "aws_route_table_association" "aws_rta2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.aws_rt.id
}

resource "aws_security_group" "aws_sg" {
  name = "terraform-created-1720"
  vpc_id = aws_vpc.vpc_custom.id

  ingress {
    description = "HTTP From VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH port"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description = "Allowing everything"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    name = "aws_sg"
  }
}

resource "aws_s3_bucket" "aws_s3" {
  bucket = "rajesh-terraform-created1720"
}

resource "aws_instance" "aws_ec2_1" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.aws_sg.id ]
  subnet_id = aws_subnet.subnet1.id
  user_data = base64encode(file("userdata.sh"))
}

resource "aws_instance" "aws_ec2_2" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.aws_sg.id ]
  subnet_id = aws_subnet.subnet2.id
  user_data = base64encode(file("userdata.sh"))
}

resource "aws_lb" "app_lb" {
  name               = "applb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.aws_sg.id]
  subnets = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "aws_lb_tg" {
  name = "my-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.vpc_custom.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.aws_lb_tg.arn
  target_id        = aws_instance.aws_ec2_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.aws_lb_tg.arn
  target_id        = aws_instance.aws_ec2_2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.aws_lb_tg.arn
    type             = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.app_lb.dns_name
}