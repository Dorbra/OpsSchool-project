#!/usr/bin/env bash
set -e

### Install Prometheus Collector
wget https://github.com/prometheus/prometheus/releases/download/v${promcol_version}/prometheus-${promcol_version}.linux-amd64.tar.gz -O /tmp/promcoll.tgz
mkdir -p ${prometheus_dir}
tar zxf /tmp/promcoll.tgz -C ${prometheus_dir}

# Create promcol configuration
mkdir -p ${prometheus_conf_dir}
tee ${prometheus_conf_dir}/prometheus.yml > /dev/null <<EOF
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets:
          - 'localhost:9090'
  - job_name: node-exporters
    consul_sd_configs:
      - server: 'localhost:8500'
    relabel_configs:
      - source_labels:
          - __address__
        target_label: __address__
        regex: '(.*):(.*)'
        replacement: ':9100'
      - source_labels:
          - __meta_consul_node
        target_label: instance
  - job_name: consul-exporters
    consul_sd_configs:
      - server: 'localhost:8500'
        services:
          - consul
    relabel_configs:
      - source_labels:
          - __address__
        target_label: __address__
        regex: '(.*):(.*)'
        replacement: ':9100'
    metrics_path: /metrics
    params:
      format:
        - prometheus
  - job_name: k8s-exporters
    consul_sd_configs:
      - server: 'localhost:8500'
        tags:
          - k8s
    relabel_configs:
      - source_labels:
          - __address__
        target_label: __address__
        regex: '(.*):(.*)'  
        replacement: ':9100'
      - source_labels:
          - __meta_consul_node
        target_label: instance
      - source_labels:
          - __meta_consul_tags
        target_label: tags
      - source_labels:
          - __meta_consul_service
        target_label: service
  - job_name: kandula-app
    metrics_path: /metrics
    consul_sd_configs:
      - server: 'localhost:8500'
        services:
          - kandula-app-service-default
    relabel_configs:
      - source_labels:
          - __address__
        target_label: __address__
        regex: '(.*):(.*)'
        replacement: '$1:9100'
      - source_labels:
          - __meta_consul_service_id
        target_label: pod

EOF

# Configure promcol service
tee /etc/systemd/system/promcol.service > /dev/null <<EOF
[Unit]
Description=Prometheus Collector
Requires=network-online.target
After=network.target

[Service]
ExecStart=${prometheus_dir}/prometheus-${promcol_version}.linux-amd64/prometheus --config.file=${prometheus_conf_dir}/prometheus.yml
ExecReload=/bin/kill -s HUP \$MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable promcol.service
systemctl start promcol.service

### add promcol service to consul
tee /etc/consul.d/promcol-9090.json > /dev/null <<"EOF"
{
  "service": {
    "id": "promcol-9090",
    "name": "promcol",
    "tags": ["promcol"],
    "port": 9090,
    "checks": [
      {
        "id": "tcp",
        "name": "TCP on port 9090",
        "tcp": "localhost:9090",
        "interval": "10s",
        "timeout": "1s"
      }
    ]
  }
}
EOF

consul reload

# grafana
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_8.4.3_amd64.deb
sudo dpkg -i grafana-enterprise_8.4.3_amd64.deb

tee /etc/grafana/provisioning/datasources/prometheus.yaml > /dev/null <<EOF
apiVersion: 1
datasources:
  - name: Prometheus-EC2
    type: prometheus
    access: server
    url: http://promcol.service.consul:9090
    isDefault: true
  - name: Prometheus-K8s
    type: prometheus
    access: proxy
    url: http://prometheus-operated-default.service.consul:9090
    isDefault: false
EOF

sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server