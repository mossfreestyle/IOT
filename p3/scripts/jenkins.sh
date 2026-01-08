docker run --name jenkins -d -p 8081:8080 -p 50000:50000 jenkins/jenkins:lts > /dev/null

"" > ../credentials/jenkins_pass.txt 2>/dev/null
sleep 5
docker cp jenkins:/var/jenkins_home/secrets/initialAdminPassword ../credentials/jenkins_pass.txt