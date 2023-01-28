FROM tomcat
ADD https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh","run"]
