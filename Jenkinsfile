void buildMFW(String device, String libc, String startClean, String makeOptions, String buildDir) {
  sh "docker-compose -f ${buildDir}/mfw/docker-compose.build.yml -p mfw_${device} run build -d ${device} -l ${libc} -c ${startClean} -m '${makeOptions}'"
}

void archiveMFW(String buildDir) {
  archiveArtifacts artifacts: "${buildDir}/bin/targets/**/*.img.gz,${buildDir}/bin/targets/**/*.bin,${buildDir}/bin/targets/**/*.img,${buildDir}/bin/targets/**/*.tar.gz", fingerprint: true
}

pipeline {
  agent none

  parameters {
    string(name:'libc', defaultValue: 'musl', description: 'lib to link against (musl or glibc)')
    string(name:'startClean', defaultValue: '0', description: 'start clean or not (0 or 1)')
    string(name:'makeOptions', defaultValue: '-j32', description: 'make options')
  }

  stages {
    stage('Build') {

      parallel {
        stage('Build x86_64') {
	  agent { label 'mfw' }

          environment {
            device = 'x86_64'
            buildDir = "tmp-mfw-${env.device}"
          }

	  stages {
            stage('Prep WS x86_64') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt x86_64') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
		emailext(to: 'seb@untangle.com', subject: "Done ${env.JOB_NAME} [${env.BUILD_NUMBER}]", body: "${env.BUILD_URL}")
                slackSend(channel: "@Seb", message: "Done : ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}")
              }
            }
          }

          post {
            success { archiveMFW(buildDir) }
          }
        }

        stage('Build wrt3200') {
	  agent { label 'mfw' }

          environment {
            device = 'wrt3200'
            buildDir = "tmp-mfw-${env.device}"
          }

	  stages {
            stage('Prep WS wrt3200') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt wrt3200') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post {
            success { archiveMFW(buildDir) }
          }
        }

        stage('Build wrt1900') {
	  agent { label 'mfw' }

          environment {
            device = 'wrt1900'
            buildDir = "tmp-mfw-${env.device}"
          }

	  stages {
            stage('Prep WS wrt1900') { 
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt wrt1900') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post { 
            success { archiveMFW(buildDir) }
          }
        }

      }
    }
  }
}

