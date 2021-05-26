pipeline {
  agent any
  tools {
  
  maven 'Maven'
   
  }
    stages {

      stage ('Checkout SCM'){
        steps {
          checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'git', url: 'https://For_demo@bitbucket.org/For_demo/appforlogin.git']]])
        }
      }
	  
	  stage ('Build')  {
	      steps {
          
            dir('java-source'){
            sh "mvn package"
          }
        }
         
      }
   
     stage ('SonarQube Analysis') {
        steps {
              withSonarQubeEnv('sonar') {
                
				dir('java-source'){
                 sh 'mvn -U clean install sonar:sonar'
                }
				
              }
            }
      }

    stage ('Artifactory configuration') {
            steps {
                rtServer (
                    id: "jfrog",
                    url: "http://3.235.177.236:8082/artifactory",
                    credentialsId: "jfrog"
                )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "jfrog",
                    releaseRepo: "java-libs-release-local",
                    snapshotRepo: "java-libs-snapshot-local"
                )

                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "jfrog",
                    releaseRepo: "java-libs-release-local",
                    snapshotRepo: "java-libs-snapshot-local"
                )
            }
    }

    stage ('Deploy Artifacts') {
            steps {
                rtMavenRun (
                    tool: "maven", // Tool name from Jenkins configuration
                    pom: 'java-source/pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER",
                    resolverId: "MAVEN_RESOLVER"
                )
         }
    }

    stage ('Publish build info') {
            steps {
                rtPublishBuildInfo (
                    serverId: "jfrog"
             )
        }
    }

    stage('Copy Dockerfile & Playbook to Ansible Server') {
            
            steps {
                  sshagent(['SSH_key']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Dockerfile ec2-user@54.165.215.226:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no create-container-image.yaml ec2-user@54.165.215.226:/home/ec2-user"
                    }
                }
            
        } 
    stage('Build Container Image') {
            
            steps {
                  sshagent(['SSH_key']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.165.215.226 -C \"sudo ansible-playbook create-container-image.yaml\""
                        
                    }
                }
            
        } 
    stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['SSH_key']) {
                       
                        sh "scp -o StrictHostKeyChecking=no create-k8s-deployment.yaml ec2-user@3.236.23.122:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@3.236.23.122:/home/ec2-user"
                    }
                }
            
        } 

    stage('Waiting for Approvals') {
            
        steps{

				input('Test Completed ? Please provide  Approvals for Prod Release ?')
			  }
            
    }     
    stage('Deploy Artifacts to Production') {
            
            steps {
                  sshagent(['SSH_key']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.236.23.122 -C \"sudo kubectl apply -f create-k8s-deployment.yaml\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.236.23.122 -C \"sudo kubectl apply -f nodePort.yaml\""
                        
                    }
                }
            
        } 
         
   } 
}