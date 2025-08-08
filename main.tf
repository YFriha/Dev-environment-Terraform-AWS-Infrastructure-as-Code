resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "mtc_igw" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "mtc_sg" {
  name        = "public_sg"
  description = "security group for public instances"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}


resource "aws_instance" "dev_node" {
  instance_type          = "t3.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.mtc_auth.id
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 8
  }

  tags = {
    name = "dev-node"
  }

  provisioner "local-exec" {
    command = templatefile("ssh-config.tpl",{
      hostname= self.public_ip,
      user = "ec2-user",
      identity_file = "~/.ssh/mtckey"
    })
    interpreter = [ "Powershell", "-Command" ]
  }
}