#!/bin/bash
useradd -m -s /bin/bash prometheus
su - prometheus -c "wget https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.linux-amd64.tar.gz"
su - prometheus -c "tar -xzvf prometheus-2.2.1.linux-amd64.tar.gz"
su - prometheus -c "rm prometheus-2.2.1.linux-amd64.tar.gz"
su - prometheus -c "mv prometheus-2.2.1.linux-amd64 prometheus/"


