# Set base image to Ubuntu 22.04
FROM ubuntu:22.04

# Set environment variables
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV STORM_VERSION=2.4.0

# Install necessary packages
RUN apt-get update && apt-get install -y \
    curl wget gnupg tar netcat unzip maven && \
    rm -rf /var/lib/apt/lists/*

# Install OpenJDK 11
RUN mkdir -p /opt/java && \
    curl -L https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1+1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.20.1_1.tar.gz | tar -xz -C /opt/java && \
    mv /opt/java/jdk-11.0.20.1+1 /opt/java/openjdk

# Download and install Apache Storm
RUN mkdir -p /opt/storm && \
    curl -L https://archive.apache.org/dist/storm/apache-storm-2.4.0/apache-storm-2.4.0.zip -o /tmp/apache-storm.zip && \
    unzip /tmp/apache-storm.zip -d /opt/storm && \
    mv /opt/storm/apache-storm-2.4.0 /opt/storm/storm && \
    rm /tmp/apache-storm.zip

# Set working directory
WORKDIR /opt/storm/storm

# Expose necessary ports
EXPOSE 8080 6627

# Default command
CMD ["bin/storm", "nimbus"]
