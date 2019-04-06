#!/bin/bash
echo "Sur quel ordinateur souhaitez-vous installer Graphana ?" ; read grafid
echo "Quel est l'administareur de l'ordinateur distant ?" ; read grafroot
echo "Quel est son mot de passe ?" ; read grafpw
yum -y install sshpass

sshpass -p "$grafpw" ssh -o StrictHostKeyChecking=no $grafroot@$grafid << EOF

	# Install grafana 
	
	wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.1.3-1.x86_64.rpm
	yum -y install grafana/ grafana-5.1.3-1.x86_64.rpm
	/sbin/chkconfig --add grafana-server
	systemctl daemon-reload
	systemctl start grafana-server
	systemctl enable grafana-server.service

wget https://github.com/prometheus/node_exporter/releases/download/v0.16.0-rc.1/node_exporter-0.16.0-rc.1.linux-amd64.tar.gz
tar -xzvf node_exporter-0.16.0-rc.1.linux-amd64.tar.gz
mv node_exporter-0.16.0-rc.1.linux-amd64 /node_exporter
cd /etc/systemd/system/
touch node_exporter.service
echo "
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/node_exporter/node_exporter

[Install]
WantedBy=default.target" > node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
firewall-cmd --add-port=9100/tcp --permanent
firewall-cmd --reload 

EOF
cd /home/prometheus/prometheus
sudo -u prometheus echo "  - job_name: 'node_exporter2'" >> prometheus.yml
sudo -u prometheus echo "    static_configs:" >> prometheus.yml
sudo -u prometheus echo "       - targets: ['$grafid:9100']" >> prometheus.yml

systemctl restart prometheus
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload 

exit

