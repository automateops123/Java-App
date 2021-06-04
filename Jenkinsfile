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
          
          sh "mv /home/jenkinsslave/workspace/Jenkins-Pipeline/java-source/target/login-1.0.war* ./tmp
          
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
  
    stage('Copy Dockerfile & Playbook to Ansible Server') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Dockerfile ec2-user@54.169.232.1:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no create-container-image.yaml ec2-user@54.169.232.1:/home/ec2-user"
                    }
                }
            
        } 
    stage('Build Container Image') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.169.232.1 -C \"sudo ansible-playbook create-container-image.yaml\""
                        
                    }
                }
            
        } 
    stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Create-k8s-deployment.yaml ec2-user@54.251.190.106:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml ec2-user@54.251.190.106:/home/ec2-user"
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
                  sshagent(['ssh_keys']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.251.190.106 -C \"sudo kubectl replace -f Create-k8s-deployment.yaml\""
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@54.251.190.106 -C \"sudo kubectl apply -f nodePort.yaml\""
                        
                    }
                }
            
        } 
         
   } 
}