resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.Terraform_Test_Salah.id
  service_name = "com.amazonaws.eu-north-1.s3"
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = "S3-Endpoint-Gateway"
  }
}
resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.route_Table_private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}