#!/bin/bash

# docker run -d \
#   --name jenkins \
#   -p 8081:8080 \
#   -p 50000:50000 \
#   -v /var/run/docker.sock:/var/run/docker.sock \
#   -v jenkins_home:/var/jenkins_home \
#   # -e JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
#   jenkins/jenkins:lts > /dev/null


docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts


mkdir -p ../credentials
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


#TODO

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

# docker exec jenkins sh -lc "
#     . /var/jenkins_home/env.sh
#     export JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN
#     echo \"CLI will use: \$JENKINS_USER_ID:\$JENKINS_API_TOKEN @ \$JENKINS_URL\"
# "


echo "All env variables are define in jenkins container"
