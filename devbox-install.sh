#!/bin/bash
ADMINUSER=$1
scriptBase=$(echo $2 | grep -P -o ".*/")
GIT_TOKEN=$3
echo "datacenter=$DATACENTER"
echo "masterVmName=$MASTERVMNAME"
echo "adminUserName=$ADMINUSER"
echo "scriptBase=$scriptBase"
echo "targetEnv=$targetEnv"

if [[ -z "$GIT_TOKEN" ]] ; then
  echo "GIT_TOKEN missing"
  exit 1
fi

echo "adding data disk"
#add managed data disk
sudo fdisk /dev/sdc << EOF
n
p



w
EOF

sudo mkfs -t ext4 /dev/sdc1

sudo mkdir -p /var/lib/docker
sudo mount /dev/sdc1 /var/lib/docker

# persist the mount
sudo bash -c 'echo "/dev/sdc1       /var/lib/docker   auto    defaults        0       0" >> /etc/fstab'

#install docker
url=$scriptBase/install_docker.sh
echo "downloading $url"
curl --header "Authorization: token $GIT_TOKEN" $url > install_docker.sh
sudo chmod +x install_docker.sh
./install_docker.sh

echo "adding user to docker group" && sudo usermod -aG docker $ADMINUSER
sudo echo "restarting docker" && sudo systemctl restart docker

sudo apt-get install -y git
