void buildMFW(String device, String libc, String startClean, String makeOptions, String buildDir) {
  sh "docker-compose -f ${buildDir}/mfw/docker-compose.build.yml -p mfw_${device} run build -d ${device} -l ${libc} -c ${startClean} -m '${makeOptions}'"
  sh "rm -fr bin/targets && cp -r ${buildDir}/bin/targets bin/"
}

void archiveMFW(String device, String libc) {
  def outputDir="tmp/artifacts"
  sh "./mfw/version-images.sh -o ${outputDir}"
  archiveArtifacts artifacts: "${outputDir}/*", fingerprint: true
  sh "rm -fr ${outputDir}"
}

pipeline {
  agent none

  triggers {
    upstream(upstreamProjects: "packetd/master, sync-settings/master, classd/master",
             threshold: hudson.model.Result.SUCCESS)
  }

  parameters {
    string(name:'libc', defaultValue: 'musl', description: 'lib to link against (musl or glibc)')
    string(name:'startClean', defaultValue: '0', description: 'start clean or not (0 or 1)')
    string(name:'makeOptions', defaultValue: '-j32', description: 'make options')
  }

  stages {
    stage('Build') {

      parallel {
        stage('x86_64') {
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
            success { archiveMFW(device, libc) }
          }
        }

        stage('wrt3200') {
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
            success { archiveMFW(device, libc) }
          }
        }

        stage('omnia') {
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
            success { archiveMFW(device, libc) }
          }
        }

        stage('wrt1900') {
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
            success { archiveMFW(device, libc) }
          }
        }

        stage('wrt32x') {
	  agent { label 'mfw' }

          environment {
            device = 'wrt32x'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
          }

	  stages {
            stage('Prep WS wrt32x') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build OpenWrt wrt32x') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post {
            success { archiveMFW(device, libc) }
          }
        }

      }
    }

    stage('Test') {
      parallel {
        stage('Test x86_64') {
	  agent { label 'mfw' }

          environment {
            device = 'x86_64'
	    rootfsTarballName = 'openwrt-x86-64-generic-rootfs.tar.gz'
	    rootfsTarballPath = "bin/targets/x86/64/${rootfsTarballName}"
	    dockerfile = 'docker-compose.test.yml'
          }

          stages {
            stage('Prep x86_64') {
              steps {
                unstash(name:"rootfs-${device}")
                sh("test -f ${rootfsTarballPath}")
		sh("mv -f ${rootfsTarballPath} mfw")
              }
            }

            stage('TCP services') {
              steps {
                dir('mfw') {
                  script {
                    try {
                      sh("docker-compose -f ${dockerfile} build --build-arg ROOTFS_TARBALL=${rootfsTarballName} mfw")
                      sh("docker-compose -f ${dockerfile} up --abort-on-container-exit --exit-code-from test")
                    } catch (exc) {
                      currentBuild.result = 'UNSTABLE'                      
                    }
                  }
                }
              }
            }
          }
        }
      }

      post {
	changed {
	  script {
	    // set result before pipeline ends, so emailer sees it
	    currentBuild.result = currentBuild.currentResult
          }
          emailext(to:'nfgw-engineering@untangle.com', subject:"${env.JOB_NAME} #${env.BUILD_NUMBER}: ${currentBuild.result}", body:"${env.BUILD_URL}")
          slackSend(channel:"#engineering", message:"${env.JOB_NAME} #${env.BUILD_NUMBER}: ${currentBuild.result} at ${env.BUILD_URL}")
	}
      }
    }

  }
}
