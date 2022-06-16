packer {
  required_plugins {
    amazon = {
      version = "~> 1.1.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name = "riju-neue-cluster-node-${local.timestamp}"
}

data "amazon-ami" "ubuntu" {
  filters = {
    name                = "ubuntu/images/*ubuntu-jammy-22.04-amd64-server-*"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  most_recent = true
  owners      = ["099720109477"]  # Canonical
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${local.ami_name}"
  instance_type = "t3.medium"
  source_ami    = "${data.amazon-ami.ubuntu.id}"
  ssh_username  = "ubuntu"

  tag {
    key   = "BillingCategory"
    value = "RijuNeue"
  }

  tag {
    key   = "BillingSubcategory"
    value = "RijuNeue:AMI"
  }

  tag {
    key   = "Name"
    value = "${local.ami_name}"
  }

  run_tag {
    key = "Name"
    value = "riju-neue-packer-builder"
  }

  run_tag {
    key = "BillingCategory"
    value = "RijuNeue"
  }

  run_tag {
    key = "BillingSubcategory"
    value = "RijuNeue:Packer"
  }
}

build {
  name    = "cluster-node"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "shell" {
    script = "${path.root}/cluster_node_provision.bash"
  }
}
