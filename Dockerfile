# Create Custom Docker Image
# Pull tomcat latest image from dockerhub 
FROM tomcat

# copy war file on to container 
COPY login-6.0.war /usr/local/tomcat/webapps/jenkins1.war
