data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  subnet_id                   = aws_subnet.public.id
  user_data                   = file("apache.sh")

}
resource "aws_instance" "web1" {
  depends_on = [ aws_instance.web ]
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.allow_tls.id]
  subnet_id                   = aws_subnet.private.id
  user_data                   = file("apache.sh")

}
resource "aws_key_pair" "deployer" {
  key_name   = var.key_pair
  public_key = file("~/.ssh/id_rsa.pub")
}