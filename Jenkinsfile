pipeline {
  agent {'javaloginapp'}
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
  
    stage('Copy Dockerfile & Playbook to Ansible Server') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Dockerfile ec2-user@13.212.181.102:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no create-container-image.yaml ec2-user@13.212.181.102:/home/ec2-user"
                    }
                }
            
        } 
    stage('Build Container Image') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@13.212.181.102 -C \"sudo ansible-playbook create-container-image.yaml\""
                        
                    }
                }
            
        } 
    stage('Copy Deployent & Service Defination to K8s Master') {
            
            steps {
                  sshagent(['ssh_keys']) {
                       
                        sh "scp -o StrictHostKeyChecking=no Create-k8s-deployment.yaml root@34.200.224.3:/home/ec2-user"
                        sh "scp -o StrictHostKeyChecking=no nodePort.yaml root@34.200.224.3:/home/ec2-user"
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
                       
                        sh "ssh -o StrictHostKeyChecking=no root@34.200.224.3 -C \"sudo kubectl apply -f Create-k8s-deployment.yaml\""
                        sh "ssh -o StrictHostKeyChecking=no root@34.200.224.3 -C \"sudo kubectl apply -f nodePort.yaml\""
                        
                    }
                }
            
        } 
         
   } 
}