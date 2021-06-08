pipeline {
  agent any
  
   environment {
     VERSION = "${BUILD_NUMBER}"
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
    
   Stage ( "Build Docker Images") {
        
         sh "docker build -t saikumar0803/jenkins:${VERSION}"
   
      
        } 
         
   }  
}
