# Nomad training-jobs
Jobs used in the Nomad training

# Running the jobs
With Nomad on your PATH, to run the job simply type:
```
nomad run <job-name>
```

# Available jobs
## logging.nomad
Contains Fluentd, Elasticsearch and Kibana for log aggregation.

## prometheus.nomad
Contains Prometheus for metrics aggregation.

## statsd.nomad
Contains the statsd_collector for grabbing Statsd events and exposing them to Prometheus.
