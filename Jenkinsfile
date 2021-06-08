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
    stage ('build image') {
        steps {

             sh "docker build -t saikumar0803/bike:6.0 ."

        }
       
    }

       stage ('docker login and push') {
         withCredentials([string(credentialsId: 'Dockerhub', variable: 'Docker')]) {
           sh "docker login -u saikumar0803 -p ${Docker}"
     
         }
        
             sh "docker push saikumar0803/bike:6.0"

        }
       
    }
   
    stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no create-k8s-deployment.yaml ec2-user@3.236.23.122:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@3.236.23.122:/home/ec2-user"
                    }
                }
            
        }     
    stage('Deploy Artifacts to Production') {
            
            steps {
                  sshagent(['ssh_keys']) {

                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.236.23.122 -C \"sudo kubectl delete deployment login-deploy\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.236.23.122 -C \"sudo kubectl apply -f create-k8s-deployment.yaml\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.236.23.122 -C \"sudo kubectl apply -f nodePort.yaml\""
                        
                    }
                }
            
        } 
}