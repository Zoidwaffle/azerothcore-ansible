# ![logo](https://raw.githubusercontent.com/azerothcore/azerothcore.github.io/master/images/logo-github.png) AzerothCore

# AzerothCore Ansible

## Introduction

Install and maintain AzerothCore easily using Ansible.

For now it will only work using a local MySQL/MariaDB installation.

This has only been tested for Debian 10 but it's likely it will work just fine for Ubuntu and other Debian-based distributions.

## Requirements

You need a target server running Debian 10 Buster where the software will be installed.

To initiate the installation, you need a Linux machine with Ansible. This can be a different machine or the target server itself.

Install the basic requirements - on Debian:
```
# If you are already root, skip the 'sudo su' command
sudo su
apt update
apt install git python-pip
pip install ansible
```

The reason for using **pip** is that the version of Ansible will be newer than if using the default from normal repositories.

## Preparations

Checkout this repository.

`git clone https://github.com/Zoidwaffle/AzerothCore-Ansible.git`

You don't need to change anything to get a basic server up and running, but you should have a look in the file:

`group_vars/all.yml`

before running Ansible in case you want to change some defaults. If you do change the defaults, be aware that some details in the guide here might differ so adjust accordingly.

Be aware that since the server will run as its own user and the game client is required for map generation, you might have to run the playbook twice. This is not an error, just see the messages and do as instructed until all is done. 

### Setup the initial parts

Initial run of Ansible. This requires root (or sudo) to install system dependancies and create the proper user. This is ONLY required for the very initial run.

Replace ***IP*** with the proper address in the examples below. Instead of the IP address you can use a DNS reference or localhost (if running this on the target server itself).

If you are root:

`ansible-playbook azerothcore.yml --extra-vars '{"target": "IP"}' -i IP, -u root --ask-pass`

If you are a sudo user:

`ansible-playbook azerothcore.yml --extra-vars '{"target": "IP"}' -i IP, -u username_here --ask-become --ask-pass`

This should create the user used for AzerothCore and provide info regarding the client folder structure.

### Make the game client accessible

To generate the various maps needed, the game client files must be accessible on the target server.

The default location for the game client is:

`/home/azerothcore/wow_client`

so copy an installed version of the game into this folder and make sure it's owned by the `azerothcore` user.

### Install the server

Now you can run the playbook again as your new user and setup everything.

`ansible-playbook azerothcore.yml --extra-vars '{"target": "IP"}' -i IP, -u azerothcore --ask-pass --ask-become`

The map extraction will take a while, so be patient! Grab some coffee, go for a walk etc..

### Running the server

Scripts to handle the server using systemd have been added - so to stop and start the services as user azerothcore do:

```
sudo systemctl start worldserver
sudo systemctl stop worldserver
sudo systemctl reload worldserver
sudo systemctl status worldserver
```

Similar for authserver:

```
sudo systemctl start authserver
sudo systemctl stop authserver
sudo systemctl reload authserver
sudo systemctl status authserver
```

To see the current status of either server and get the CLI as user azerothcore do:

```
screen -r authserver
screen -r worldserver
```

### Important info regarding folder structure

This is the default structure and some important files with comments.
```
 .
 ├── azerothcore_release           # This is a symlink to the latest build
 ├── gazerothcore_release_b3a96    # Latest build (the hash suffix will change)
 │   ├── azerothcore_db            # Folder with database tools and backups
 │   │   ├── backup.sh             # Backup all databases easily
 │   │   ├── create_databases.sql  # Create the user and databases needed
 │   │   └── drop_databases.sh     # Drop the databases and user (if recreating from scratch)
 │   └── azerothcore_server        # The compiled server
 │       ├── bin                   # Main binaries
 │       ├── data                  # DBC and map-files
 │       ├── etc                   # Server configuration files
 │       └── log                   # Log files
 ├── azerothcore_source            # The source code
 │   └── modules                   # Various modules
 └─── wow_client                   # The game client
```

When AzerothCore is compiled, there will be created a folder with the latest commit as reference. Example:

`azerothcore_release_90a10a`

There will also be created a symlink, to indicate the active version of the software. Example:

`azerothcore_release -> azerothcore_release_90a10a`

When compiling a new version, the old version will not be overwritten. So you will end up with multiple folders such as:

```
azerothcore_release_be09e0
azerothcore_release_90a10a
```

If you are compiling often, this will take up a lot space, so remember to clean up once in a while.

The benefit is that this allows you to roll back to previous builds fairly easily.

Example as how to roll back to a previous build - you are in the `/home/azerothcore/` folder:


```
# Stop the running services
sudo systemctl stop authserver
sudo systemctl stop worldserver
# Restore database to previous state - be careful, consider a backup first
zcat azerothcore_release_be09e0/azerothcore_db/acore_characters.sql.gz | mysql acore_characters
zcat azerothcore_release_be09e0/azerothcore_db/acore_auth.sql.gz | mysql acore_auth
zcat azerothcore_release_be09e0/azerothcore_db/acore_world.sql.gz | mysql acore_world
# Change active version of the software
rm azerothcore_release
ln -s azerothcore_release_be09e0 azerothcore_release
# Start the services again
sudo systemctl start authserver
sudo systemctl start worldserver
```
