#!groovy

import jenkins.install.*
import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

println "--> disabling initial setup wizard'"
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)

println "--> creating local user 'admin'"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
//hudsonRealm.createAccount('admin','admin')
hudsonRealm.createAccountWithHashedPassword('admin','PASSWORD_PLACEHOLDER')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
