variable "do_token" {
    type = string
}

variable "domain_name" {
    type = string 
    default = "samanthagloria.me"
}

variable "cluster_name" {
    type = string
    default = "final-project-cluster"
}

variable "cluster_region" {
    type = string
    default = "ams3"
}

variable "cluster_version" {
    type = string 
    default = "1.25.4-do.0"
}

variable "node_size" {
    type = string
    default = "s-2vcpu-4gb"
}

variable "node_count" {
    type = number
    default = "3"
}

variable "nginx_svc_name" {
    type = string
    default = "nginx-ingress-ingress-nginx-controller"
}

variable "grafana_admin_user" {
    type = string
}  

variable "grafana_admin_password" {
    type = string
}