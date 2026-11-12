# Firewall for our web server. Written in a hurry.
resource "aws_security_group" "web" {
  name        = "hello-devops-web"
  description = "Firewall rules for the web server"

  ingress {
    description = "SSH for admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
}
