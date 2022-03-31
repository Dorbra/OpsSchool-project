#!/usr/bin/env bash
set -e

### set consul version
CONSUL_VERSION="1.8.5"
echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "Installing dependencies..."
apt-get -yqq install unzip dnsmasq &>/dev/null
echo "Configuring dnsmasq..."
cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF
systemctl restart dnsmasq
cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1ƒ
Domains=~consul
EOF
systemctl restart systemd-resolved.service
echo "Fetching Consul..."
cd /tmp
curl -sLo consul.zip https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
mv consul /usr/local/bin/consul
# Setup Consul
mkdir -p /opt/consul
mkdir -p /etc/consul.d
mkdir -p /run/consul
tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "advertise_addr": "$PRIVATE_IP",
  "data_dir": "/opt/consul",
  "datacenter": "dorbra",
  "encrypt": "uDBV4e+LbFW3019YKPxIrg==",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=consul_server tag_value=true"],
  "enable_script_checks": true,
  "server": false
}
EOF

# Create user & grant ownership of folders
useradd consul
chown -R consul:consul /opt/consul /etc/consul.d /run/consul
# Configure consul service
tee /etc/systemd/system/consul.service > /dev/null <<"EOF"
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target
[Service]
User=consul
Group=consul
PIDFile=/run/consul/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service

tee /home/ubuntu/jenkins.json > /dev/null <<EOF
{
  "name": "jenkins",
  "tags": [
    "jenkins-agent"
  ],
  "port": 8080,
  "checks": [
    {
  "name": "tcp-8080",
  "tcp": "localhost:8080",
      "interval": "5s",
      "timeout": "20s"
    }
  ]
}
EOF

### Install Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v${node_exporter_version}/node_exporter-${node_exporter_version}.linux-amd64.tar.gz -O /tmp/node_exporter.tgz
mkdir -p ${prometheus_dir}
tar zxf /tmp/node_exporter.tgz -C ${prometheus_dir}
ƒ
# Configure node exporter service
tee /etc/systemd/system/node_exporter.service > /dev/null <<EOF
[Unit]
Description=Prometheus node exporter
Requires=network-online.target
After=network.target

[Service]
ExecStart=${prometheus_dir}/node_exporter-${node_exporter_version}.linux-amd64/node_exporter
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable node_exporter.service
systemctl start node_exporter.service

# Consul hack
sleep 10
sudo /usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
sleep 20
curl -X PUT -d @/home/ubuntu/jenkins.json http://localhost:8500/v1/agent/service/register ;echo
exit 0

sudo touch testfile.txt
echo "HELLO JENKINS MASTER SH TEMPLATE!!!!!!!"