# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat:latest

# Maintainer
MAINTAINER "SAI - demoq" 

# copy war file on to container 
COPY ./demoq.war /usr/local/tomcat/webapps
