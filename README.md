# ec2-docker

A single EC2 instance running a Dockerized web app, provisioned entirely with
Terraform. The instance bootstraps itself via cloud-init (`user_data`): installs
Docker, builds the image and runs the container at first boot. No config
management tool - just Terraform.

## Requirements

`terraform`, `awscli` (creds configured).

## Setup

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ec2_docker -N ""
cd terraform
cp terraform.tfvars.example terraform.tfvars   # set allowed_ssh_cidr + key path
```

`allowed_ssh_cidr` is `$(curl -s ifconfig.me)/32`.

## Up

```bash
cd terraform
terraform init
terraform apply
```

Give it a minute after apply for cloud-init to install Docker and start the
container, then open the `url` from the output. To watch it boot:

```bash
ssh ubuntu@<ip> 'sudo tail -f /var/log/cloud-init-output.log'
```

## Editing the app

Change `app/index.html`, then `terraform apply` again. Because `user_data`
changed, the instance is recreated and re-bootstrapped with the new content.

## Down

```bash
./scripts/cost-guard.sh
cd terraform && terraform destroy
```

## Notes

- Public subnet, no NAT gateway - throwaway box.
- `t3.micro` keeps it inside the free tier.
- Everything runs from `user_data`, so the whole deploy is one `terraform apply`.
  The tradeoff vs a config tool: the script only runs at first boot, so changes
  mean recreating the instance (handled by `user_data_replace_on_change`).

## TODO

- swap the static page for a small Go/Python service
- move bootstrap into an immutable AMI (Packer) instead of boot-time install
- add an HTTPS listener
