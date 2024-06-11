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
        # option to "wait" until api service becomes available
        # can be omitted as K8S deployment is responsible for setting "client" service to desired state
        # init_container {
        #   name  = "pre-client"
        #   image = "alpine:3.12"
        #   command = [
        #     "/bin/sh", "-c", "wget --no-verbose --tries=1 --spider http://api.default.svc.cluster.local:3000/status || exit 1"
        #   ]
        # }

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
