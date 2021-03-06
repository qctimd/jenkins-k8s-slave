
FROM debian:stretch

RUN apt-get update -y
RUN apt-get install -y default-jdk git curl dos2unix gettext
RUN apt-get install -y python python-pip python-dev libxml2-dev libxslt-dev zlib1g-dev
RUN pip install bzt

# Jenkins slave setup

ARG VERSION=3.7

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar

RUN chmod 755 /usr/share/jenkins
RUN chmod 644 /usr/share/jenkins/slave.jar

RUN mkdir /root/.jenkins
VOLUME /root/.jenkins
WORKDIR /root

COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]

# set environment variables
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV PATH /opt/google-cloud-sdk/bin:$PATH

# install google cloud sdk
RUN curl https://sdk.cloud.google.com | bash && mv /root/google-cloud-sdk /opt
RUN gcloud components install kubectl
