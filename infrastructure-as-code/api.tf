resource "kubernetes_deployment" "api" {
  metadata {
    name = "api"
    labels = {
      app = "api"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }

      spec {
        container {
          image             = "api"
          name              = "api"
          image_pull_policy = "Never"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "api" {
  metadata {
    name = kubernetes_deployment.api.metadata.0.labels.app
  }
  spec {
    selector = {
      app = kubernetes_deployment.api.metadata.0.labels.app
    }

    port {
      port        = 3000
      target_port = 3000
    }
  }
}
