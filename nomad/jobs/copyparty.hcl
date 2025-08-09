variable "volume_id" {
  type = string
}

variable "attachment_mode" {
  type = string
}

variable "access_mode" {
  type = string
}

variable "fs_type" {
  type = string
}

job "copyparty" {
  datacenters = ["*"]

  group "copyparty" {
    count = 1

    network {
      port "http" {
        to = 3923
      }
    }

    service {
      name = "copyparty"
      port = "http"

      tags = [
        "traefik.enable=true",
      ]

      check {
        type     = "http"
        path     = "/?reset=/._"
        interval = "1m"
        timeout  = "2s"
      }
    }

    volume "copyparty" {
      type            = "csi"
      source          = var.volume_id
      read_only       = false
      attachment_mode = var.attachment_mode
      access_mode     = var.access_mode
      per_alloc       = false

      mount_options {
        fs_type     = var.fs_type
        mount_flags = ["noatime"]
      }
    }

    task "server" {
      driver = "docker"

      config {
        image = "ghcr.io/9001/copyparty-ac"
        args  = ["-c", "${NOMAD_TASK_DIR}/copyparty.conf"]
        ports = ["http"]
      }

      volume_mount {
        volume      = "copyparty"
        destination = "/w"
        read_only   = false
      }


      template {
        destination = "${NOMAD_TASK_DIR}/copyparty.conf"

        data = <<-EOF
        [global]
          e2dsa  # enable file indexing and filesystem scanning
          e2ts   # enable multimedia indexing
          ansi   # enable colors in log messages

          # q, lo: /cfg/log/%Y-%m%d.log   # log to file instead of docker

          # p: 3939          # listen on another port
          # ipa: 10.89.      # only allow connections from 10.89.*
          # df: 16           # stop accepting uploads if less than 16 GB free disk space
          # ver              # show copyparty version in the controlpanel
          # grid             # show thumbnails/grid-view by default
          # theme: 2         # monokai
          # name: datasaver  # change the server-name that's displayed in the browser
          # stats, nos-dup   # enable the prometheus endpoint, but disable the dupes counter (too slow)
          # no-robots, force-js  # make it harder for search engines to read your server


        [accounts]
          ed: wark  # username: password


        [/]            # create a volume at "/" (the webroot), which will
          /w           # share /w (the docker data volume)
          accs:
            rw: *      # everyone gets read-write access, but
            rwmda: ed  # the user "ed" gets read-write-move-delete-admin
        EOF
      }

      resources {
        cpu    = 100
        memory = 256
      }
    }
  }
}
