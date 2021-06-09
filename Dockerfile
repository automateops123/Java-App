# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat:latest

# copy war file on to container 
COPY ./login-1.0.war /usr/local/tomcat/webapps/java.war
