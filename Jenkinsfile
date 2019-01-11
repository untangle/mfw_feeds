void buildMFW(String device, String libc, String startClean, String makeOptions, String buildDir) {
  sh "docker-compose -f ${buildDir}/mfw/docker-compose.build.yml -p mfw_${device} run build -d ${device} -l ${libc} -c ${startClean} -m '${makeOptions}'"
  sh "rm -fr bin/targets && cp -r ${buildDir}/bin/targets bin/"
}

void archiveMFW() {
  archiveArtifacts artifacts: "bin/targets/**/*.img.gz,bin/targets/**/*.bin,bin/targets/**/*.img,bin/targets/**/*.tar.gz", fingerprint: true
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
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
          }

	  stages {
            stage('Prep WS x86_64') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt x86_64') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
                stash(name:"rootfs-${device}", includes:"bin/targets/**/*generic-rootfs.tar.gz")
              }
            }
          }

          post {
            success { archiveMFW() }
          }
        }

        stage('Build wrt3200') {
	  agent { label 'mfw' }

          environment {
            device = 'wrt3200'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
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
            success { archiveMFW() }
          }
        }

        stage('Build omnia') {
	  agent { label 'mfw' }

          environment {
            device = 'omnia'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
          }

	  stages {
            stage('Prep WS omnia') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt omnia') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post {
            success { archiveMFW() }
          }
        }

        stage('Build wrt1900') {
	  agent { label 'mfw' }

          environment {
            device = 'wrt1900'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
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
            success { archiveMFW() }
          }
        }

      }

      post {
	always {
	  script {
	    // set result before pipeline ends, so emailer sees it
	    currentBuild.result = currentBuild.currentResult
	  }
          emailext(to:'seb@untangle.com', subject:"${env.JOB_NAME} #${env.BUILD_NUMBER}: ${currentBuild.result}", body:"${env.BUILD_URL}")
          slackSend(channel:"@Seb", message:"${env.JOB_NAME} #${env.BUILD_NUMBER}: ${currentBuild.result} at ${env.BUILD_URL}")
	}
      }

    }

    stage('Test') {
      parallel {
        stage('Test x86_64') {
	  agent { label 'mfw' }

          environment {
            device = 'x86_64'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
	    rootfsTarball = 'bin/targets/x86/64/openwrt-x86-64-generic-rootfs.tar.gz'
	    dockerfile = "build/docker-compose.test.yml"
          }

          steps {
            unstash(name:"rootfs-${device}")
            shell("test -f ${rootfsTarball}")
	    shell("docker-compose -f ${dockerfile} build --build-arg ROOTFS_TARBALL= ${rootfsTarball} mfw")
	    shell("docker-compose -f ${dockerfile} up -d")
	    shell("docker-compose -f ${dockerfile} down")
          }
        }
      }

      post {
        failure {
          script {
            currentBuild.result = 'UNSTABLE'
          }
        }
      }

    }

  }
}
