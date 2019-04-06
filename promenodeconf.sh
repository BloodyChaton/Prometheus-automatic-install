#!/bin/bash
cd /home/prometheus/prometheus
sudo -u prometheus echo "  - job_name: 'node_exporter'" >> prometheus.yml
sudo -u prometheus echo "    static_configs:" >> prometheus.yml
sudo -u prometheus echo "       - targets: ['localhost:9100']" >> prometheus.yml

systemctl restart prometheus
