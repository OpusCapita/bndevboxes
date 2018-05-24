#!/bin/bash
username=$1
public_key=$2

print_usage() {
  echo "usage: add_user.sh username public_key"
  exit 1
}

if [[ -z "$public_key" ]] ; then 
  print_usage
fi

sudo useradd -s /bin/bash -m $username;
sudo usermod -aG sudo $username;
sudo usermod -aG docker $username;

sudo mkdir -p /home/$username/.ssh;
sudo chown $username:$username /home/$username/.ssh;

echo "adding public key";
sudo /bin/bash -c "echo \"$public_key\" > /home/$username/.ssh/authorized_keys";
sudo chown $username:$username /home/$username/.ssh/authorized_keys;
sudo /bin/bash -c "echo \"$username ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers";

