#!/bin/bash

sudo gitlab-ctl stop
sudo apt purge gitlab-ce
sudo apt remove gitlab-ce


sudo rm -rf /var/opt/gitlab
sudo rm -rf /etc/gitlab
sudo rm -rf /var/log/gitlab
sudo rm -rf /opt/gitlab