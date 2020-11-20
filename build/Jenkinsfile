// this Jenkinsfile itself does pretty much nothing, but allows us to
// easily declare a Jenkins project and then use it as an upstream for
// the main MFW pipeline

pipeline {
  agent any

  stages {
    stage('Build') {
      agent any
      steps {
	sh "true"
      }
    }

  }
}
