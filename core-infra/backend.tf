terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "basitha-gamage-aws"

    workspaces {
      name = "terraform-aws"
    }
  }
}