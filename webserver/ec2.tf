    
    resource "aws_instance" "web_server" {
      ami           = "ami-0e1d35993cb249cee" # Replace with a valid AMI for your region
      instance_type = "t3.micro"
      subnet_id     = aws_subnet.mgmt.id
      security_groups = [aws_security_group.inbound.id]
      key_name = aws_key_pair.web_server_1.key_name
      associate_public_ip_address = true
      tags = {
        Name = "my-web-server"
      }
    }
    

resource "aws_key_pair" "web_server_1" {
  key_name   = "web_server_1"
  public_key = file("/home/karce/Cloudfare_challenge/webserver/pub_key.pub")
  
}
