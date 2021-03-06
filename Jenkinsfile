pipeline {
  agent any
  environment{
       DOCKER_TAG = getDockerTag()
  }
  tools {
  
  maven 'maven'
   
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
      stage ('Build Docker image') {
        steps {
       
             sh "cp /var/lib/jenkins/workspace/Jenkins-Pipeline/java-source/target/login-1.0.war ."
             sh "docker build . -t saikumar0803/javaapp:${DOCKER_TAG} "

        }
       
    }

       stage ('docker login and push') {
           steps {
               withCredentials([string(credentialsId: 'Dockerhub', variable: 'Docker')]) {
               sh "docker login -u saikumar0803 -p ${Docker}"
     
         }
        
             sh "docker push saikumar0803/javaapp:${DOCKER_TAG}"

        }
       
    }
   
    stage('Copy Definition files to K8s Master') {
            
            steps {
                  sh "chmod +x ChangeTag.sh"
                  sh "./ChangeTag.sh ${DOCKER_TAG}"
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no K8s-deployement.yaml ec2-user@3.0.99.117:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@3.0.99.117:/home/ec2-user"
                    }
                }
            
        }     
      stage('Deploy Production') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       script{
                          try{
                               sh "ssh -o StrictHostKeyChecking=no ec2-user@3.0.99.117 -C \"sudo kubectl apply -f . --validate=false\""
                          }catch(error){
                               sh "ssh -o StrictHostKeyChecking=no ec2-user@3.0.99.117 -C \"sudo kubectl create -f . --validate=false\""
                        
                    }
                }
            }
         } 
      }     
    }
}


def getDockerTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
