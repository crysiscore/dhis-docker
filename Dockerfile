#Base image for dhis
#Download base image sebian 16.04
FROM debian:stretch-slim

LABEL mantainer="Agnaldo Samuel  <asamuel@pedaids.org>"

# Update Ubuntu Software repository
# Install dependencies
RUN apt-get update && \
apt-get install -y curl wget apt-utils net-tools inetutils-ping iproute

# Download and install Apache tomcat 7
RUN wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.94/bin/apache-tomcat-7.0.94.tar.gz  && \
tar -xzf apache-tomcat-7.0.94.tar.gz -C /usr/local/  && \
mv /usr/local/apache-tomcat-7.0.94  /usr/local/tomcat7 && \
rm -rf /usr/local/tomcat7/webapps/examples && \
rm -rf /usr/local/tomcat7/webapps/docs && \
rm -rf /usr/local/tomcat7/webapps/ROOT && \
rm -f apache-tomcat-7.0.94.tar.gz

# Install Oracle JDK
RUN wget https://www.dropbox.com/s/64ywzo9iavw0spn/jdk-8u5-linux-x64.tar.gz?dl=0  && \
    mv jdk-8u5-linux-x64.tar.gz?dl=0  jdk-8u5-linux-x64.tar.gz && \
    mkdir /opt/jdk && \
    tar -zxf jdk-8u5-linux-x64.tar.gz -C /opt/jdk && \
    rm jdk-8u5-linux-x64.tar.gz && \
    update-alternatives --install /usr/bin/java  java  /opt/jdk/jdk1.8.0_05/bin/java 100 && \
    update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk1.8.0_05/bin/javac 100 && \
    update-alternatives --install /usr/bin/jar   jar   /opt/jdk/jdk1.8.0_05/bin/jar 100

RUN apt-get clean && rm -rf  /tmp/* /var/tmp/*

## DHIS staff 
RUN useradd -d /home/dhis -m dhis -s /bin/false
COPY config  /home/dhis/config
RUN chown dhis:dhis /home/dhis/config

COPY dhis.war   /usr/local/tomcat7/webapps/
COPY setenv.sh    /usr/local/tomcat7/bin/


ENV CATALINA_HOME /usr/local/tomcat7
ENV PATH $PATH:$CATALINA_HOME/bin


VOLUME ["/usr/local/tomcat7/webapps","/root/"]

WORKDIR /usr/local/tomcat7/bin

EXPOSE 8080

# Launch Tomcat
CMD ["catalina.sh", "run"]



