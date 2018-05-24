#!/bin/bash

# install nvm
sudo apt-get -y update
sudo apt-get -y install build-essential
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash

#open new shell
bash

nvm install node




