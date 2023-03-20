terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.11.0"
    }

  }
}

provider "digitalocean" {
  token = var.do_token

}

provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.portf_cluster.endpoint
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.portf_cluster.kube_config.0.cluster_ca_certificate
  )

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "doctl"
    args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
    "--version=v1beta1", digitalocean_kubernetes_cluster.portf_cluster.id]
  }
}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.portf_cluster.endpoint
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.portf_cluster.kube_config.0.cluster_ca_certificate
    )
      exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "doctl"
    args = ["kubernetes", "cluster", "kubeconfig", "exec-credential",
    "--version=v1beta1", digitalocean_kubernetes_cluster.portf_cluster.id]
  }
}
}

#Remote backend

/*terraform {
  backend "s3" {
    endpoint                    = "ams3.digitaloceanspaces.com"
    region                      = "us-west-1"
    key                         = "terraform.tfstate"
    bucket                      = "k8-terraform-state" 

    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}*/

# Add domain
resource "digitalocean_domain" "my-domain" {
  name       = var.domain_name
}

resource "digitalocean_record" "main_record" {
  depends_on = [ data.kubernetes_service_v1.ingress_svc ]
  domain = digitalocean_domain.my-domain.id
  type   = "A"
  name   = "@"
  value  = data.kubernetes_service_v1.ingress_svc.status.0.load_balancer.0.ingress.0.ip
}

resource "digitalocean_record" "sock_record" {
  domain = digitalocean_domain.my-domain.id
  type   = "A"
  name   = "www"
  value  = "159.223.242.4"
}

