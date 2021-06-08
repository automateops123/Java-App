pipeline {
  agent any
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
	  
	 stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Create-k8s-deployment.yaml ec2-user@54.179.249.90:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@54.179.249.90:/home/ec2-user"
                    }
                }
            
        } 
   stage('Deploy Artifacts to Production') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.179.249.90 -C \"sudo kubectl apply -f Create-k8s-deployment.yaml\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.179.249.90 -C \"sudo kubectl apply -f nodePort.yaml\""
                        
                    }
                }
            
    
