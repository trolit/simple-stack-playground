provider "kubernetes" {
  host           = "https://localhost:6443" # kubectl cluster-info
  config_path    = "~/.kube/config"         # ls -la ~/.kube/config
  config_context = "docker-desktop"         # kubectl config current-context
}
