job "prometheus" {
	region = "global"
	datacenters = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
	type = "service"

	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "prometheus" {
		restart {
			attempts = 6
			interval = "1m"
			delay = "10s"
			mode = "delay"
		}

		task "prometheus" {
			driver = "docker"

			config {
				image = "xebia/prometheus:0.0.5"
				port_map {
					http = 9090
				}
			}

			env {
				CONSUL_ADDR = "172.17.0.1:8500"
				CONSUL_TAGS = "'statsd-exporter'"
			}

			service {
				name = "prometheus"
				tags = ["prometheus"]
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
				memory = 256
				network {
					mbits = 10
					port "http" {}
				}
			}
		}
	}
}
