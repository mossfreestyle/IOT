#!/bin/bash


read -p "Want to clear Jenkins? [y/N] " YORN

if [[ "$YORN" == "y" || "$YORN" == "Y" ]]; then
    docker rm -f jenkins
    docker rmi jenkins/jenkins:lts
    rm -rf ../credentials/jenkins_pass.txt
    rm -rf ../credentials/jenkins_api_token.txt
    unset TOKEN
    unset JENKINS_ADMIN_PASS
fi