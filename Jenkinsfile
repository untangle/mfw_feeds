pipeline {
  agent { label 'mfw' }

  environment {
    device = 'x86_64'
    lib = 'musl'
    startClean = '0'
    makeOptions = '-j32'
  }

  stages {
    stage('Build x86_64') {
      steps {
        sh 'docker-compose -f mfw/Dockerfile-build.yml run build -d ${device} -l ${lib} -c ${startClean} -m "${makeOptions}"'
      }
    }
  }
}
