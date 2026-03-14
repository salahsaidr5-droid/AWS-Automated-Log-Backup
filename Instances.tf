//Data source
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"] 
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
//EC2 Web Server
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.EC2_Web_Server.id
  key_name="Salah_Test_key"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.SG_Web_Server.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "EC2_Web_Server"
  }
}
//EC2 Backup Server
resource "aws_instance" "Backup_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.EC2_Backup_Server.id
  key_name="Salah_Test_key"
  vpc_security_group_ids = [aws_security_group.SG_Backup_Server.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags = {
    Name = "EC2_Backup_Server"
  }
}