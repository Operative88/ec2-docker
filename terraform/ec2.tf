resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = aws_key_pair.this.key_name

  # Bootstrap entirely from Terraform via cloud-init: install Docker, write
  # the app, build and run the container at first boot. (No Ansible.)
  user_data = templatefile("${path.module}/templates/user_data.sh.tftpl", {
    index_html = file("${path.module}/../app/index.html")
    dockerfile = file("${path.module}/../app/Dockerfile")
  })

  # Recreate the box when the bootstrap script or app changes, so a
  # `terraform apply` after editing the app actually redeploys it.
  user_data_replace_on_change = true

  tags = { Name = "${var.project_name}-web" }
}
