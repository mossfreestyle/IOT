import hudson.model.User
import jenkins.security.ApiTokenProperty

def user = User.get('admin')
def apiTokenProperty = user.getProperty(ApiTokenProperty.class)

def token = apiTokenProperty.generateNewToken('CLI-Generated-Token')
user.save()

println token.plainValue