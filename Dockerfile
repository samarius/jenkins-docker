FROM ubuntu:14.04
MAINTAINER samariuson@gmail.com

RUN apt-get update 
RUN apt-get install -y curl
RUN curl https://get.docker.com/gpg | apt-key add -
RUN echo deb http://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update 
RUN apt-get install -y \
	iptables \
	ca-certificates \
	openjdk-6-jdk \
	git-core \
	rsync 

ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war

RUN for plugin in \
	chucknorris \
	greenballs \
	scm-api \
	git-client \
	git \
	ws-cleanup \
	publish-over-ssh \
	build-with-parameters; \
    	do curl -sf -o $JENKINS_HOME/plugins/${plugin}.hpi \
       		-L $JENKINS_MIRROR/plugins/${plugin}/latest/${plugin}.hpi ; \
	done

RUN useradd jenkins -d $JENKINS_HOME
RUN chown -R jenkins:jenkins /opt/jenkins
ADD ssh-files $JENKINS_HOME/.ssh

EXPOSE 8080

CMD sudo -u jenkins java -jar /opt/jenkins/jenkins.war
