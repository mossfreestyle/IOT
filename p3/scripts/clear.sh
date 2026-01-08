#!/bin/bash

k3d cluster list

read -p "Cluster Name: " name

if [ -z "$name" ]; then
    echo "Nothing to delete"
else
    k3d cluster delete "$name"
fi

read -p "Want to clear docker images? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker system prune -af
fi