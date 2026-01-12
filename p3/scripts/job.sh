#!/bin/bash

mkdir -p ../credentials/

read -sp "GitHub Token: " GTOKEN
echo
read -p "GitHub Username: " GUSERNAME

read -sp "Docker Token: " DTOKEN
echo
read -p "Docker Username: " DUSERNAME

cat <<EOF > ../credentials/github.xml
<?xml version='1.1' encoding='UTF-8'?>
<com.cloudbees.plugins.credentials.SystemCredentialsProvider plugin="credentials@1465.ve8c9516d78b_f">
  <domainCredentialsMap class="hudson.util.CopyOnWriteMap\$Hash">
    <entry>
      <com.cloudbees.plugins.credentials.domains.Domain>
        <specifications/>
      </com.cloudbees.plugins.credentials.domains.Domain>
      <java.util.concurrent.CopyOnWriteArrayList>
        <com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
          <scope>GLOBAL</scope>
          <id>github-creds</id>
          <description></description>
          <username>${GUSERNAME}</username>
          <password>${GTOKEN}</password>
          <usernameSecret>true</usernameSecret>
        </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
      </java.util.concurrent.CopyOnWriteArrayList>
    </entry>
  </domainCredentialsMap>
</com.cloudbees.plugins.credentials.SystemCredentialsProvider>
EOF



cat <<EOF > ../credentials/docker.xml
<?xml version='1.1' encoding='UTF-8'?>
<com.cloudbees.plugins.credentials.SystemCredentialsProvider plugin="credentials@1465.ve8c9516d78b_f">
  <domainCredentialsMap class="hudson.util.CopyOnWriteMap\$Hash">
    <entry>
      <com.cloudbees.plugins.credentials.domains.Domain>
        <specifications/>
      </com.cloudbees.plugins.credentials.domains.Domain>
      <java.util.concurrent.CopyOnWriteArrayList>
        <com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
          <scope>GLOBAL</scope>
          <id>dockerhub-creds</id>
          <description></description>
          <username>${DUSERNAME}</username>
          <password>${DTOKEN}</password>
          <usernameSecret>true</usernameSecret>
        </com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
      </java.util.concurrent.CopyOnWriteArrayList>
    </entry>
  </domainCredentialsMap>
</com.cloudbees.plugins.credentials.SystemCredentialsProvider>
EOF