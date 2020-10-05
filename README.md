# AzerothCore Ansible

## Introduction

Install and maintain AzerothCore easily using Ansible.

For now it will only work using a local MySQL/MariaDB installation.

This has only been tested for Debian 10 but it's likely it will work just fine for Ubuntu and other Debian-based distributions.

## Requirements

You need a target server running Debian 10 Buster where the software will be installed.

To initiate the installation, you need a Linux machine with Ansible. This can be a different machine or the target server itself.

Install the basic requirements - on Debian as root:
`sudo su
apt update
apt install git python-pip
pip install ansible`

The reason for using **pip** is that the version of Ansible will be newer.

## Preparations

Checkout this repository.

git clone https://github.com/Zoidmann/AzerothCore-Ansible.git

You don't need to change anything to get a basic server up and running, but you should have a look in the file:

`group_vars/all.yml`

before running Ansible in case you want to change some defaults. If you do change the defaults, be aware that some details in the guide here might differ so adjust accordingly.

Be aware that since the server will run as its own user and the game client is required for map generation, you might have to run the playbook twice. This is not an error, just see the messages and do as instructed until all is done. 

Instead of the IP address in the example, you can use a DNS reference or localhost (if running this on the target server itself).

### Setup the initial parts

Initial run of Ansible. This requires root (or sudo) to install system dependancies and create the proper user. This is ONLY required for the very initial run.

If you are root:

`ansible-playbook azerothcore.yml --extra-vars '{"target": "192.168.x.y"}' -i 192.168.y.y, -u root --ask-pass`

If you are a sudo user:

`ansible-playbook azerothcore.yml --extra-vars '{"target": "192.168.x.y"}' -i 192.168.y.y, -u username_here --ask-become --ask-pass`

This should create the user used for AzerothCore and provide info regarding the client folder structure.

The default location for the game client is

`/home/azerothcore/wow_client`

so copy an installed version of the game into this folder and make sure it's owned by the `azerothcore` user.

### Install the server

Now you can run the playbook again as your new user and setup everything.

`ansible-playbook azerothcore.yml --extra-vars '{"target": "192.168.x.y"}' -i 192.168.x.y, -u azerothcore --ask-pass --ask-become`

### Running the server

Scripts to handle the server using systemd have been added - so to stop and start the services as user azerothcore do:

`sudo systemctl start worldserver
sudo systemctl stop worldserver
sudo systemctl reload worldserver
sudo systemctl status worldserver`

Similar for authserver:

`sudo systemctl start authserver
sudo systemctl stop authserver
sudo systemctl reload authserver
sudo systemctl status authserver`

To see the current status of either server and get the CLI as user azerothcore do:

`screen -r authserver
screen -r worldserver`
