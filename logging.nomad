job "logging" {
	region = "global"
	datacenters = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
	type = "service"

	group "logging" {
		restart {
			attempts = 6
			interval = "1m"
			delay = "10s"
			mode = "delay"
		}

		task "elasticsearch" {
			driver = "docker"

			config {
				image = "elasticsearch:2.3.3"
				port_map {
					http = 9200
          es = 9300
				}
			}

			service {
				name = "elasticsearch"
				tags = ["http"]
				port = "http"
				check {
					name = "alive"
					type = "tcp"
					interval = "10s"
					timeout = "2s"
				}
			}

			resources {
				cpu = 500
				memory = 512
				network {
					mbits = 10
					port "http" {
            static = 9200
          }
          port "es" {
            static = 9300
          }
				}
			}
		}

    task "fluentd" {
			driver = "docker"

			config {
				image = "xebia/nomad-fluentd:0.1.0"
			}

			resources {
				cpu = 256
				memory = 512
				network {
					mbits = 10
				}
			}
		}

    task "kibana" {
      driver = "docker"

      config {
				image = "kibana:4.5.1"
				port_map {
					http = 5601
				}
			}

			service {
				name = "kibana"
				tags = ["http"]
				port = "http"
				check {
					name = "alive"
					type = "tcp"
					interval = "10s"
					timeout = "2s"
				}
			}

			resources {
				cpu = 256
				memory = 128
				network {
					mbits = 10
					port "http" {}
				}
			}

      env {
        ELASTICSEARCH_URL = "http://elasticsearch.service.consul:9200"
      }
    }
	}
}
