pipeline {
  agent {label 'javaloginapp'}
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
          
           sh " mv /home/jenkinsslave/workspace/Jenkins-Pipeline/java-source/target/login-6.0* /tmp"
          
            dir('java-source'){
            sh "mvn package"
          }
        }
         
      }
   stage('Copy Dockerfile & Playbook to Ansible Server') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Dockerfile ec2-user@54.254.205.226:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no create-container-image.yaml ec2-user@54.254.205.226:/home/ec2-user"
                    }
                }
            
        } 
    stage('Build Container Image') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.254.205.226 -C \"sudo ansible-playbook create-container-image.yaml\""
                        
                    }
                }
            
        } 
    stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Create-k8s-deployment.yaml ec2-user@54.179.104.67:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@54.179.104.67:/home/ec2-user"
                    }
                }
            
        } 

}
