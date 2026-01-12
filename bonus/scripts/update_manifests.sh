#!/bin/bash

sudo sh -c 'wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq > /dev/null 2>&1' 
sudo chmod +x /usr/bin/yq

echo "yq installed (use to update the version of the deployment)"

echo "Choose a version of the app to push:"

echo "1 or 2"

read -p "Version: " input

repo="git@github.com:M-F-7/mfernand-manifests.git"
repo_dir="mfernand-manifests"

case $input in
1) v="v1";;
2) v="v2";;
*) echo "Invalid input, the version 1 will be set by default"; v="v1";;
esac



echo "Making a push to $repo with the version $v"

cd ../../
rm -rf mfernand-manifests
git clone $repo > /dev/null > /dev/null 2>&1
echo "$repo_dir cloned"

yq -i ".spec.template.spec.containers[0].image = \"mfzeroseven/iot:${v}\"" mfernand-manifests/confs/deployment.yml

cd $repo_dir

git add .
git commit -m "Updating manifests from the script with the version: $v" > /dev/null 2>&1

echo "Commited with: Updating manifests from the script with the version: $v"

if git push > /dev/null 2>&1; then
    echo "Push done"
else
    echo "Push failed"
fi


cd ..
rm -rf "$repo_dir"

echo "Deleting $repo_dir"

echo "✅"
