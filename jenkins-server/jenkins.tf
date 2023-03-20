resource "digitalocean_droplet" "jenkins" {
  image  = "ubuntu-20-04-x64"
  name   = "jenkins-server"
  region = "ams3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["${var.digitalocean_ssh_fingerprint}"]
  user_data = file("jenkins-server-script.sh")
}

resource "digitalocean_firewall" "jenkins" {
  name        = "jenkins-firewall"
  droplet_ids = [digitalocean_droplet.jenkins.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]    
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]    
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "8080"
    source_addresses = ["0.0.0.0/0"]    
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }

    outbound_rule {
    protocol         = "tcp"
    port_range       = "0-0"
    destination_addresses = ["0.0.0.0/0"]
  }

}

