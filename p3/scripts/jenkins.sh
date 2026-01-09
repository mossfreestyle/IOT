#!/bin/bash

docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts > /dev/null

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



docker exec jenkins curl -s -o /var/jenkins_home/jenkins-cli.jar \
                              http://localhost:8080/jnlpJars/jenkins-cli.jar

until curl -s http://localhost:8081/scriptText --user admin:$JENKINS_ADMIN_PASS -d "script=println('ok')" > /dev/null; do
    echo "Waiting the CLI"
    sleep 1
done

echo "Jenkins CLI is installed"

TOKEN=$(curl -s -u "admin:$JENKINS_ADMIN_PASS" \
    --data-urlencode "script=$(cat generate_token.groovy)" \
    http://localhost:8081/scriptText)
    

TOKEN=$(echo "$TOKEN" | tr -d '\r\n')

echo "API Token generated"

echo -n "$TOKEN" > ../credentials/jenkins_api_token.txt

# export JENKINS_URL=http://localhost:8081
# export JENKINS_USER_ID=admin
# export JENKINS_API_TOKEN="$(cat ../credentials/jenkins_api_token.txt)"


# docker exec -u root jenkins sh -c "echo 'JENKINS_URL=http://localhost:8080' >> /etc/environment"
# docker exec -u root jenkins sh -c "echo 'JENKINS_USER_ID=admin' >> /etc/environment"
# docker exec -u root jenkins sh -c "echo 'JENKINS_API_TOKEN=$TOKEN' >> /etc/environment"

docker exec jenkins sh -c "echo 'export JENKINS_URL=http://localhost:8080' > /var/jenkins_home/env.sh"
docker exec jenkins sh -c "echo 'export JENKINS_USER_ID=admin' >> /var/jenkins_home/env.sh"
docker exec jenkins sh -c "echo 'export JENKINS_API_TOKEN=$TOKEN' >> /var/jenkins_home/env.sh"


echo "All env variables are define in jenkins container"

docker exec jenkins sh -lc ". /var/jenkins_home/env.sh && \
        java -jar /var/jenkins_home/jenkins-cli.jar \
        -s \$JENKINS_URL \
        -auth \$JENKINS_USER_ID:\$JENKINS_API_TOKEN \
        help"
