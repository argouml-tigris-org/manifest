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
        gerritReview labels: [Verified:0], message: """Build starts.

Build has these steps:
1. Fetch i.e. clean and run repo sync.
2. Build each of the defined repos.

If these are all successful, it is scored as Verified."""
        timeout(time:1, unit: 'HOURS') {
          cleanWs deleteDirs:true, notFailBuild: true
          sh 'repo init -u https://github.com/argouml-tigris-org/manifest.git'
          sh 'repo sync'
        }
        gerritReview labels: [:], message: "Fetched without error."
      }
    }
    stage('build') {
        steps {
            script {
                def dirList = sh(script: 'ls', returnStdout: true).split()
                for (name in dirList) {
                    stage(name) {
                        timeout(time:1, unit: 'HOURS') {
                            dir(name) {
                                withMaven() {
                                    sh '$MVN_CMD -B compile'
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    stage ('report') {
        steps {
            gerritReview labels: [:], message: "Tests run without error."
            sh 'git status' // See if there are files to ignore.
        }
    }
  }
  post {
    success { gerritReview labels: [Verified: 1], message: 'Build succeeded.' }
    unstable { gerritReview labels: [Verified: 0], message: 'Build is unstable' }
    failure { gerritReview labels: [Verified: -1], message: 'Build failed.' }
  }
}
