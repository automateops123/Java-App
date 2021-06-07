# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat

# copy war file on to container 
COPY ./iwayQApp-2.0-RELEASE.war /usr/local/tomcat/webapps/jenkins1.war
