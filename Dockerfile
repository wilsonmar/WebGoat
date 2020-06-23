FROM openjdk:8-jdk

# Artifact versions
ARG CONTRAST_AGENT_VERSION=3.7.5.15480-1
ARG WEBGOAT_VERSION=8.0.0.M21

# Install Contrast: using apt-get
RUN apt-get update && apt-get install apt-transport-https
RUN curl https://pkg.contrastsecurity.com/api/gpg/key/public | apt-key add -
RUN echo "deb https://pkg.contrastsecurity.com/debian-public/ all contrast" | tee /etc/apt/sources.list.d/contrast-all.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install contrast-java-agent=${CONTRAST_AGENT_VERSION}

# Set Java environment variable to use Contrast profiler
ENV JAVA_TOOL_OPTIONS=-javaagent:/opt/contrast/contrast-agent.jar

WORKDIR /app

ADD "https://github.com/WebGoat/WebGoat/releases/download/v${WEBGOAT_VERSION}/webgoat-server-${WEBGOAT_VERSION}.jar" /app/webgoat.jar

ENTRYPOINT [ "java", "-jar", "/app/webgoat.jar", "--server.port=8080", "--server.address=0.0.0.0" ]
