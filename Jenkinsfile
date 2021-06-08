node{

   stage("Git Clone"){
       git url: "https://For_demo@bitbucket.org/For_demo/appforlogin.git", branch: "master"
       
    } 
    
    stage("MVN Package"){
      def mavenHome= tool name: "maven",type:"maven"
      sh "${mavenHome}/bin/mvn package
   }
   
}