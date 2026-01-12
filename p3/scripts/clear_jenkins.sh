#!/bin/bash


read -p "Want to delete Jenkins container and credentials? [y/N] " YORN

if [[ "$YORN" == "y" || "$YORN" == "Y" ]]; then
    docker rm -f jenkins
    docker network rm jenkins-net
    rm -rf ../credentials/jenkins_pass.txt
    rm -rf ../credentials/jenkins_api_token.txt
    rm -rf ../credentials/docker_id.txt
    rm -rf ../credentials/docker.xml
    rm -rf ../credentials/github.xml
fi
    

read -p "Want to delete Jenkins image? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker rmi jenkins/jenkins:lts
fi

read -p "Want to delete Jenkins volume? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker volume rm -f jenkins_home
fi
