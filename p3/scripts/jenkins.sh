docker run -d \
  --name jenkins \
  -p 8081:8080 \
  -p 50000:50000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts > /dev/null

mkdir -p ../credentials
"" > ../credentials/jenkins_pass.txt 2>/dev/null
sleep 5
docker cp jenkins:/var/jenkins_home/secrets/initialAdminPassword ../credentials/jenkins_pass.txt