#!/bin/bash
set -e

sudo touch USERDATA_SUCCESS.txt

echo "rm -rf /etc/dnsmasq.d/10-consul"
rm -rf /etc/dnsmasq.d/10-consul
sleep 3
echo "rm -rf /etc/systemd/resolved.conf"
rm -rf /etc/systemd/resolved.conf
sleep 3
echo "rm -rf /usr/local/bin/consul"
rm -rf /usr/local/bin/consul
sleep 3
echo "rm -rf /opt/consul"
rm -rf /opt/consul
sleep 3
echo "deluser consul"
deluser consul
sleep 3
echo "rm -rf /run/consul"
rm -rf /run/consul
sleep 3
echo "rm -rf /etc/consul.d/config.json"
rm -rf /etc/consul.d/config.json
sleep 3
echo "rm -rf /etc/systemd/system/consul.service"
rm -rf /etc/systemd/system/consul.service
sleep 3

## install consul
sleep 30
echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

sleep 5
echo "Installing dependencies..."
apt-get -q update

sleep 5

echo "Installing dependencies..."
apt-get -yq install unzip dnsmasq

sleep 10

echo "Configuring dnsmasq..."
cat << EODMCF >/etc/dnsmasq.d/10-consul
# Enable forward lookup of the 'consul' domain:
server=/consul/127.0.0.1#8600
EODMCF

sleep 10
echo "systemctl restart dnsmasq"
systemctl restart dnsmasq

sleep 10

echo "/etc/systemd/resolved.conf"
cat << EOF >/etc/systemd/resolved.conf
[Resolve]
DNS=127.0.0.1
Domains=~consul
EOF
sleep 10

echo "systemctl restart systemd-resolved.service"
systemctl restart systemd-resolved.service

sleep 10
echo "Fetching Consul..."
cd /tmp
curl -sLo consul.zip https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip

sleep 20

echo "Installing Consul..."
unzip consul.zip >/dev/null
chmod +x consul
mv consul /usr/local/bin/consul
sleep 10

# Setup Consul
echo "mkdir"
mkdir -p /opt/consul
sleep 3
mkdir -p /etc/consul.d
sleep 3
mkdir -p /run/consul
sleep 6

echo "tee /etc/consul.d/config.json"
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
  "node_name": "jenkins-server",
  "enable_script_checks": true,
  "server": false
}
EOF

sleep 10
# Create user & grant ownership of folders
echo "useradd consul"
useradd consul
chown -R consul:consul /opt/consul /etc/consul.d /run/consul

sleep 20
# Configure consul service
echo "Configure consul service"
tee /etc/systemd/system/consul.service > /dev/null <<EOF
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
ExecReload=/bin/kill -s HUP \$MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

sleep 20

systemctl daemon-reload
systemctl enable consul.service
systemctl start consul.service

sleep 25
echo "jenkins_server.json"
tee /etc/consul.d/jenkins_server.json > /dev/null <<EOF
{
"services": [
    {
    "name":"jenkins-server",
    "tags": [
        "server"
    ],
    "port": 8080,
    "checks": [
        {
        "name": "HTTP health",
        "tcp": "localhost:8080",
        "interval": "5s",
        "timeout": "10s"
        }
    ]
    }
]
}
EOF

sleep 10
echo "systemctl reload consul"
systemctl reload consul
systemctl restart consul