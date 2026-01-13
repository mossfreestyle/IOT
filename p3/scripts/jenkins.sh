#!/bin/bash

mkdir -p ../credentials
getent group docker | cut -d: -f3 > ../credentials/docker_id.txt
DOCKER_GID=$(cat ../credentials/docker_id.txt)

docker network create jenkins-net > /dev/null

docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  --group-add $DOCKER_GID \
  --network jenkins-net \
  jenkins/jenkins:lts


"" > ../credentials/jenkins_pass.txt 2>/dev/null

echo "Waiting for Jenkins to be fully ready..."

until curl -sI http://localhost:8081/login | grep -q "X-Jenkins:"; do
    sleep 1
done

echo "Jenkins is fully ready."


echo "Jenkins is running on 8081"

docker cp jenkins:/var/jenkins_home/secrets/initialAdminPassword ../credentials/jenkins_pass.txt
export JENKINS_ADMIN_PASS="$(cat ../credentials/jenkins_pass.txt)"

curl -s -u "admin:$JENKINS_ADMIN_PASS" http://localhost:8081/login > /dev/null

docker exec jenkins curl -s -o /var/jenkins_home/jenkins-cli.jar \
                              http://localhost:8080/jnlpJars/jenkins-cli.jar

echo "Jenkins CLI is installed"


docker cp generate_token.groovy jenkins:/var/jenkins_home/generate_token.groovy

TOKEN=$(docker exec jenkins sh -c "
  java -jar /var/jenkins_home/jenkins-cli.jar \
    -s http://localhost:8080 \
    -auth admin:'"$JENKINS_ADMIN_PASS"' \
    groovy = < /var/jenkins_home/generate_token.groovy")

    

TOKEN=$(echo "$TOKEN" | tr -d '\r\n')

echo "API Token generated"

echo -n "$TOKEN" > ../credentials/jenkins_api_token.txt


docker exec jenkins sh -c "echo 'export JENKINS_URL=http://localhost:8080' > /var/jenkins_home/env.sh"
docker exec jenkins sh -c "echo 'export JENKINS_USER_ID=admin' >> /var/jenkins_home/env.sh"
docker exec jenkins sh -c "echo 'export JENKINS_API_TOKEN=$TOKEN' >> /var/jenkins_home/env.sh"


docker exec jenkins sh -lc "
    export PATH=/opt/java/openjdk/bin:\$PATH
    . /var/jenkins_home/env.sh
    export JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN
    java -jar /var/jenkins_home/jenkins-cli.jar \
        -s \$JENKINS_URL \
        -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
        help
"


echo "All env variables are define in jenkins container"

docker exec -u root jenkins apt-get update > /dev/null
docker exec -u root jenkins apt-get install -y docker.io  > /dev/null
docker exec -u root jenkins usermod -aG docker jenkins













# rentrer le mdp jenkins

#skip la user creation

#define the jenkins as the default one

#install recommanded plugins

#install docker pipeline
#install cloudbees-credentials
#install docker build and docker publish









# docker exec jenkins bash -c "echo 2.452.1 > /var/jenkins_home/jenkins.install.InstallUtil.lastExecVersion"
# docker exec jenkins bash -c "echo 2.452.1 > /var/jenkins_home/jenkins.install.UpgradeWizard.state"
# docker exec jenkins bash -c "echo RUNNING > /var/jenkins_home/jenkins.install.InstallState"
# #plugins
# docker exec jenkins jenkins-plugin-cli --plugins "workflow-aggregator git github matrix-auth credentials-binding"
# docker exec jenkins jenkins-plugin-cli --plugins docker-workflow

# docker exec jenkins java -jar /var/jenkins_home/jenkins-cli.jar \
#   -s $URL \
#   -auth $USER_ID:$API_TOKEN \
#   list-plugins


# echo "All plugins are installed"

# docker exec jenkins java -jar /var/jenkins_home/jenkins-cli.jar \
#   -s $URL \
#   -auth $USER_ID:$API_TOKEN \
#   safe-restart

# until curl -s -o /dev/null -w "%{http_code}" "$URL/cli/" | grep -q "200"; do
#   sleep 2
#   echo "Still waiting..."
# done

# echo "CLI is ready."

read -p "Waiting set up " name

# docker exec -i jenkins bash -c ". /var/jenkins_home/env.sh \
    # export JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN" \
    # java -jar /var/jenkins_home/jenkins-cli.jar -s $JENKINS_URL -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN create-credentials-by-xml system::system::jenkins _ < ../credentials/credentials.xml


# docker exec jenkins bash -c "
#   . /var/jenkins_home/env.sh &&
#   export PATH=/opt/java/openjdk/bin:\$PATH &&
#   java -jar /var/jenkins_home/jenkins-cli.jar \
#     -s \$JENKINS_URL \
#     -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
#     create-credentials-by-xml system::system::jenkins _ 
#     " < ../credentials/credentials.xml

# curl -X POST \
#   -u "admin:$TOKEN" \
#   -H "Content-Type: text/xml" \
#   --data-binary @../credentials/credentials.xml \
#   "http://localhost:8081/credentials/store/system/domain/_/createCredentials"

docker cp ../credentials/github.xml jenkins:/tmp/github.xml
docker cp ../credentials/docker.xml jenkins:/tmp/docker.xml



docker exec jenkins bash -c "
  java -jar /var/jenkins_home/jenkins-cli.jar \
    -s http://jenkins:8080 \
    -auth admin:$TOKEN \
    create-credentials-by-xml system::system::jenkins _ < /tmp/github.xml
"

docker exec jenkins bash -c "
  java -jar /var/jenkins_home/jenkins-cli.jar \
    -s http://jenkins:8080 \
    -auth admin:$TOKEN \
    create-credentials-by-xml system::system::jenkins _ < /tmp/docker.xml
"


# docker exec -i jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s http://jenkins:8080 -auth admin:$TOKEN create-credentials-by-xml system::system::jenkins _ < ../credentials/github.xml
# docker exec -i jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s http://jenkins:8080 -auth admin:$TOKEN create-credentials-by-xml system::system::jenkins _ < ../credentials/docker.xml

# docker exec jenkins bash -c "
#   . /var/jenkins_home/env.sh &&
#   export PATH=/opt/java/openjdk/bin:\$PATH &&
#   java -jar /var/jenkins_home/jenkins-cli.jar \
#     -s \$JENKINS_URL \
#     -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
#     create-credentials-by-xml system::system::jenkins _ <<'EOF'
# $(cat ../credentials/credentials.xml)
# EOF
# "


echo "Credentials créé."


# docker exec -i jenkins bash -c ". /var/jenkins_home/env.sh \
#     export JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN" \
#     java -jar /var/jenkins_home/jenkins-cli.jar -s $JENKINS_URL -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN create-job test < ../confs/config.xml

# docker exec -i jenkins bash -c "
#   . /var/jenkins_home/env.sh &&
#   export PATH=/opt/java/openjdk/bin:\$PATH &&
#   java -jar /var/jenkins_home/jenkins-cli.jar \
#     -s \$JENKINS_URL \
#     -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
#     create-job test
#   " < ../confs/config.xml

docker exec -i jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s $JENKINS_URL -auth admin:$TOKEN create-job test < ../confs/config.xml


read -p "Define dockerhub-creds" input

read -p "Version a build: " input

# docker exec -i jenkins bash -c ". /var/jenkins_home/env.sh \
    # export JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN" \
    # java -jar /var/jenkins_home/jenkins-cli.jar -s $JENKINS_URL -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN build test -f -p VERSION=input

# docker exec -i jenkins bash -c "
#   . /var/jenkins_home/env.sh &&
#   export PATH=/opt/java/openjdk/bin:\$PATH &&
#   java -jar /var/jenkins_home/jenkins-cli.jar \
#     -s \$JENKINS_URL \
#     -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
#     build test -f -p VERSION=$input"

docker exec -i jenkins java -jar /var/jenkins_home/jenkins-cli.jar -s $JENKINS_URL -auth admin:$TOKEN build test -f -p VERSION=input