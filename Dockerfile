FROM tomcat
ADD target/SimpleTomcatWebApp.war /usr/local/tomcat/webapps
EXPOSE 8085
CMD ["catalina.sh","run"]
