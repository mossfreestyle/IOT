#!/bin/bash


read -p "Want to delete Jenkins container and credentials? [y/N] " YORN

if [[ "$YORN" == "y" || "$YORN" == "Y" ]]; then
    docker rm -f jenkins
    rm -rf ../credentials/jenkins_pass.txt
    rm -rf ../credentials/jenkins_api_token.txt
    unset TOKEN
    unset JENKINS_ADMIN_PASS
fi
    

read -p "Want to delete Jenkins image? [y/N] " yorn

if [[ "$yorn" == "y" || "$yorn" == "Y" ]]; then
    docker rmi jenkins/jenkins:lts
fi