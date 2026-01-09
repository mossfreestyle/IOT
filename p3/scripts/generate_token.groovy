import jenkins.model.*
import hudson.models.*

def user = User.get("admin")
def tokenStore = user.getProperty(jenkins.security.ApiTokenProperty.class)
def token = tokenStore.tokenStore.generateNewToken("bootstrap")
user.save()

