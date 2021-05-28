# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat:latest

# Maintainer
MAINTAINER "SAI - demoq" 

# copy war file on to container 
COPY ./iwayq.war /usr/local/tomcat/webapps
