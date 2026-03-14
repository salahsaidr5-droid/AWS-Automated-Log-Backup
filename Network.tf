// VPC 
resource "aws_vpc" "Terraform_Test_Salah" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Terraform_Test_Salah"
  }
}
// Subent Public and Private
data "aws_availability_zones" "availability" {

}
resource "aws_subnet" "EC2_Web_Server" {
  vpc_id            = aws_vpc.Terraform_Test_Salah.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.availability.names[0]
  tags = {
    Name = "EC2_Web_Server"
  }
}
resource "aws_subnet" "EC2_Backup_Server" {
  vpc_id            = aws_vpc.Terraform_Test_Salah.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.availability.names[1]
  tags = {
    Name = "EC2_Backup_Server"
  }
}

//Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.Terraform_Test_Salah.id

  tags = {
    Name = "main"
  }
}
//VPC NAT Gateway and EIP
resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = {
    Name="NEt_EIP"
  }
}
resource "aws_nat_gateway" "gw_Nat" {
  allocation_id =aws_eip.eip.id
  subnet_id     = aws_subnet.EC2_Web_Server.id

  tags = {
    Name = "gw_Nat"
  }

  depends_on = [aws_internet_gateway.gw]
}
// Route table for Public Subent
resource "aws_route_table" "route_Table_public" {
  vpc_id = aws_vpc.Terraform_Test_Salah.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "Route_Public"
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.EC2_Web_Server.id
  route_table_id = aws_route_table.route_Table_public.id
}
// Route table for Private Subent
resource "aws_route_table" "route_Table_private" {
  vpc_id = aws_vpc.Terraform_Test_Salah.id
  route {
   cidr_block = "0.0.0.0/0"
   nat_gateway_id= aws_nat_gateway.gw_Nat.id
  }
  tags = {
    Name = "Route_Private"
  }
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.EC2_Backup_Server.id
  route_table_id = aws_route_table.route_Table_private.id
}



//Security group for EC2 Backup Server

resource "aws_security_group" "SG_Backup_Server" {
  name        = "SG_Backup_Server"
  description = "Allow inbound traffic and all outbound traffic for Private Subnet"
  vpc_id      = aws_vpc.Terraform_Test_Salah.id

  tags = {
    Name = "SG_Backup_Server"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_for-SG_Public" {
  security_group_id = aws_security_group.SG_Backup_Server.id
  referenced_security_group_id = aws_security_group.SG_Web_Server.id
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_inbound" {
  security_group_id = aws_security_group.SG_Backup_Server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

//Security group for EC2 Web Server
resource "aws_security_group" "SG_Web_Server" {
  name        = "SG_Web_Server"
  description = "Allow inbound traffic and all outbound traffic for Public Subnet"
  vpc_id      = aws_vpc.Terraform_Test_Salah.id

  tags = {
    Name = "SG_Web_Server"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_HTTP" {
  security_group_id = aws_security_group.SG_Web_Server.id
  cidr_ipv4         ="0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_HTTPS" {
  security_group_id = aws_security_group.SG_Web_Server.id
  cidr_ipv4         ="0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}
resource "aws_vpc_security_group_ingress_rule" "allow_SSH" {
  security_group_id = aws_security_group.SG_Web_Server.id
  cidr_ipv4   = "${chomp(data.http.my_ip.response_body)}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_backup" {
  security_group_id            = aws_security_group.SG_Web_Server.id 
  referenced_security_group_id = aws_security_group.SG_Backup_Server.id 
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
}
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.SG_Web_Server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}