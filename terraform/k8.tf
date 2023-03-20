#Provisioning cluster
resource "digitalocean_kubernetes_cluster" "portf_cluster" {
  name    = var.cluster_name
  region  = var.cluster_region
  version = var.cluster_version
  auto_upgrade = true
  ha = true
  
  node_pool {
    name       = "my-pool"
    size       = var.node_size
    auto_scale = true
    node_count = var.node_count
    min_nodes  = 3
    max_nodes  = 7
  }
}

#Provision ingress for portfolio app 
resource "helm_release" "nginx_ingress" {
  depends_on = [ digitalocean_kubernetes_cluster.portf_cluster ]
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

   set {
    name  = "controller.publishService.enabled"
    value = true
  }
}


#Provision Postgres database
resource "helm_release" "postgres" {

  depends_on = [digitalocean_kubernetes_cluster.portf_cluster]
  name       = "postgres"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "postgresql"

  values = [ "${file("../k8s/psql-values.yml")}" ]
  }

resource "helm_release" "cert-manager" {

  depends_on = [digitalocean_kubernetes_cluster.portf_cluster]
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true
  version    = "1.8.0"
   set {
    name  = "installCRDs"
    value = true
  }

}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  create_namespace = true

   set {
    name  = "grafana.adminUser"
    value = var.grafana_admin_user
  }
   set {
    name  = "grafana.adminPassword"
    value = var.grafana_admin_password
  }
}

#Provision service or ingress for portfolio app 
data "kubernetes_service_v1" "ingress_svc" {
  depends_on = [ helm_release.nginx_ingress ]
  metadata {
    name = var.nginx_svc_name
  }
}


output "my-kubeconfig"{
  value = digitalocean_kubernetes_cluster.portf_cluster.kube_config.0.raw_config 
  sensitive = true
}

