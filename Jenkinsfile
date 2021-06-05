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
}