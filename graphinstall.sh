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

EOF
firewall-cmd --add-port=3000/tcp --permanent
firewall-cmd --reload 
exit

