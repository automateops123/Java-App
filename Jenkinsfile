node{

   stage("Git Clone"){
       git url: "https://For_demo@bitbucket.org/For_demo/appforlogin.git", branch: "master"
       
    } 
    
    stage("MVN Package"){
      sh "/usr/local/apache-maven/bin/mvn package"
   }
   
}