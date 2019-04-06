su - prometheus -c "wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0-rc.1/node_exporter-0.16.0-rc.1.linux-amd64.tar.gz"
su - prometheus -c "tar -xzvf node_exporter-0.16.0-rc.1.linux-amd64.tar.gz"
su - prometheus -c "mv node_exporter-0.16.0-rc.1.linux-amd64 /home/prometheus/node_exporter"
cd /etc/systemd/system/
touch node_exporter.service
echo "
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/home/prometheus/node_exporter/node_exporter

[Install]
WantedBy=default.target" > node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
