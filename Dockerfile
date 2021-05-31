# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat:latest

# Maintainer
MAINTAINER "SAI" 

# copy war file on to container 
COPY ./login.war /usr/local/tomcat/webapps
