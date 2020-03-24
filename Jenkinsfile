void buildMFW(String device, String libc, String startClean, String makeOptions, String buildDir) {
  sshagent (credentials: ['buildbot']) {
    sh "docker-compose -f ${buildDir}/mfw/docker-compose.build.yml -p mfw_${device} run build -d ${device} -l ${libc} -c ${startClean} -m '${makeOptions}' -v ${env.BRANCH_NAME}"
  }
  sh "rm -fr bin/targets bin/packages tmp/version.date"
  sh "mkdir -p bin tmp"
  sh "cp -r ${buildDir}/bin/targets ${buildDir}/bin/packages bin/"
  sh "cp -r ${buildDir}/tmp/version.date tmp/"
}

void archiveMFW(String device) {
  def outputDir="tmp/artifacts"
  sh "./mfw/version-images.sh -d ${device} -o ${outputDir} -c -t \$(cat tmp/version.date)"
  archiveArtifacts artifacts: "${outputDir}/*", fingerprint: true
  sh "rm -fr ${outputDir}"
}

pipeline {
  agent none

  triggers {
    upstream(upstreamProjects: "packetd/${env.BRANCH_NAME}, sync-settings/${env.BRANCH_NAME}, classd/${env.BRANCH_NAME}, feeds/${env.BRANCH_NAME}, admin/${env.BRANCH_NAME}",
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

            stage('Build x86_64') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
                stash(name:"rootfs-${device}", includes:"bin/targets/**/*generic-rootfs.tar.gz")
              }
            }
          }

          post {
            success { archiveMFW(device) }
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

            stage('Build wrt3200') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post {
            success { archiveMFW(device) }
          }
        }

        // stage('omnia') {
	//   agent { label 'mfw' }

        //   environment {
        //     device = 'omnia'
        //     buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
        //   }

	//   stages {
        //     stage('Prep WS omnia') {
        //       steps { dir(buildDir) { checkout scm } }
        //     }

        //     stage('Build omnia') {
        //       steps {
        //         buildMFW(device, libc, startClean, makeOptions, buildDir)
        //       }
        //     }
        //   }

        //   post {
        //     success { archiveMFW(device) }
        //   }
        // }

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

            stage('Build wrt1900') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post { 
            success { archiveMFW(device) }
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

            stage('Build wrt32x') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post { 
            success { archiveMFW(device) }
          }
        }

        stage('espressobin') {
	  agent { label 'mfw' }

          environment {
            device = 'espressobin'
            buildDir = "${env.HOME}/build-mfw-${env.BRANCH_NAME}-${device}"
          }

	  stages {
            stage('Prep WS espressobin') {
              steps { dir(buildDir) { checkout scm } }
            }

            stage('Build espressobin') {
              steps {
                buildMFW(device, libc, startClean, makeOptions, buildDir)
              }
            }
          }

          post {
            success { archiveMFW(device) }
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

    stage('Test') {
      parallel {
        stage('Test x86_64') {
	  agent { label 'mfw' }

          environment {
            device = 'x86_64'
	    rootfsTarballName = 'mfw-x86-64-generic-rootfs.tar.gz'
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
                      unstable('TCP services test failed')
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
          slackSend(channel:"#team_engineering", message:"${env.JOB_NAME} #${env.BUILD_NUMBER}: ${currentBuild.result} at ${env.BUILD_URL}")
	}
      }
    }

  }
}
