#!/bin/bash
set -e

echo "======================"
echo "Add Swap Space..."
echo "----------------------"
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo bash -c "echo '/swapfile swap swap defaults 0 0' >> /etc/fstab"
sudo free -h

echo "======================"
echo "Add OpenCR Port Rule ..."
echo "----------------------"
sudo cat <<EOF > /etc/udev/rules.d/99-opencr-cdc.rules
ATTRS{idVendor}=="0483" ATTRS{idProduct}=="5740", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
ATTRS{idVendor}=="0483" ATTRS{idProduct}=="df11", MODE:="0666"
ATTRS{idVendor}=="fff1" ATTRS{idProduct}=="ff48", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
ATTRS{idVendor}=="10c4" ATTRS{idProduct}=="ea60", ENV{ID_MM_DEVICE_IGNORE}="1", MODE:="0666"
EOF
sudo udevadm control --reload-rules 
sudo udevadm trigger

echo "======================"
echo "Install Docker & Docker Compose..."
echo "----------------------"
sudo apt-get update
sudo apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=arm64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -yq docker-ce docker-ce-cli containerd.io 
sudo apt-get install -yq docker-compose

echo "======================"
echo "Auto start docker daemon..."
echo "----------------------"
sudo systemctl enable docker

echo "======================"
echo "Add Docker permission for user \"ubuntu\"..."
echo "----------------------"
sudo usermod -aG docker ubuntu
newgrp docker 

echo "======================"
echo "Add Custom registry..."
echo "----------------------"
sudo touch /etc/docker/daemon.json
sudo cat <<EOF > /etc/docker/daemon.json
{
    "insecure-registries": ["192.168.16.205:5000"]
}
EOF
sudo systemctl restart docker.service

echo "======================"
echo "DONE"
echo "----------------------"