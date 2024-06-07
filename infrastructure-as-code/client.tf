resource "kubernetes_deployment" "client" {
  metadata {
    name = "client"
    labels = {
      app = "client"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "client"
      }
    }

    template {
      metadata {
        labels = {
          app = "client"
        }
      }

      spec {
        container {
          image             = "client"
          name              = "client"
          image_pull_policy = "Never" # tells to not fetch image but look after local one instead

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# directs traffic to a pod
resource "kubernetes_service" "client" {
  metadata {
    name = kubernetes_deployment.client.metadata.0.labels.app
  }

  spec {
    selector = {
      app = kubernetes_deployment.client.metadata.0.labels.app
    }

    port {
      node_port   = 31000 # outside port
      port        = 80    # port of service
      target_port = 80    # port of app running inside the container
    }

    type = "NodePort"
  }
}
