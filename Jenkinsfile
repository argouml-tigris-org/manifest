#!groovy

// This is the tests performed on the manifest repo.
// The minimal requirement to be included in the default.xml
// are set here.

if (env.GERRIT_API_URL == null) {
  this.gerritComment = { dict -> }
  this.gerritReview = { dict -> }
}


pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10', daysToKeepStr: '100'))
  }
  agent {
    dockerfile {
      args '-v maven-repo:/.m2 -v maven-repo:/root/.m2'
    }
  }
  environment {
    GERRIT_CREDENTIALS_ID = 'gerrithub-user'
  }
  stages {
    stage('fetch') {
      steps {
        gerritReview labels: [Verified:0], message: """Build starts."""
        timeout(time:1, unit: 'HOURS') {
          cleanWs deleteDirs:true,
                  notFailBuild: true,
                  patterns: [[pattern: 'repo/**', type: 'INCLUDE']]

          sh '''git branch -D master
                git branch master
                mkdir repo
                cd repo
                repo init -u ..
                repo sync'''
        }
      }
    }
  }
  post {
    success { gerritReview labels: [Verified: 1], message: 'Build succeeded.' }
    unstable { gerritReview labels: [Verified: 0], message: 'Build is unstable' }
    failure { gerritReview labels: [Verified: -1], message: 'Build failed.' }
    always {
      cleanWs cleanWhenAborted: false,
              cleanWhenFailure: false,
              cleanWhenNotBuilt: false,
              cleanWhenUnstable: false,
              deleteDirs: true,
              notFailBuild: true,
              patterns: [[pattern: 'repo/**', type: 'INCLUDE']]
    }
  }
}
