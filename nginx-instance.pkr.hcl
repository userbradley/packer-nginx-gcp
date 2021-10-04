packer {
  required_plugins {
    googlecompute = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/googlecompute"
    }
  }
}

source "googlecompute" "nginx" {
  project_id           = "project"
  source_image         = "ubuntu-1604-xenial-v20210928"
  ssh_username         = "bysd"
  ssh_private_key_file = "/Users/bysd/.ssh/id_rsa"
  zone                 = "europe-west2-c"
  subnetwork           = "bysd-vpc-subnetwork"
  machine_type         = "f1-micro"
  tags                 = ["ssh"]
  preemptible          = true
  image_name = "bysd-nginx-image"
}

build {
  sources = ["sources.googlecompute.nginx"]
  name    = "bysd-nginx-image"

  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    inline = ["sudo -s",
      "apt-get update -y",
      "apt-get install nginx -y",
      "echo $(hostname) > /var/www/html/index.html",
      "systemctl restart nginx"
    ]
  }
}

