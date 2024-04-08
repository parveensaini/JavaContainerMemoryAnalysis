FROM ubuntu:latest

ENV JEMALLOC_VERSION=5.0.1

RUN apt-get update && \
    apt-get install -yq wget pwgen gcc make bzip2 && \
    rm -rf /var/lib/apt/lists/* && \
    wget -q https://github.com/jemalloc/jemalloc/releases/download/$JEMALLOC_VERSION/jemalloc-$JEMALLOC_VERSION.tar.bz2 && \
    tar jxf jemalloc-*.tar.bz2 && \
    rm jemalloc-*.tar.bz2 && \
    cd jemalloc-* && \
    ./configure --enable-prof --enable-stats --enable-debug --enable-fill && \
    make && \
    make install && \
    cd - && \
    rm -rf jemalloc-* && \
    apt-get remove -yq wget pwgen gcc make bzip2 && \
    rm -rf /usr/share/doc /usr/share/man && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

ENV LD_PRELOAD=/usr/local/lib/libjemalloc.so \
    MALLOC_CONF=prof:true,prof_leak:true,lg_prof_interval:26,lg_prof_sample:16

RUN mkdir -p /usr/share/man/man1
# Install OpenJDK-11
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk-headless && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

RUN apt-get install -y binutils && \
    apt-get install -y graphviz;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME

# Create a directory to store the application
RUN mkdir /app
RUN mkdir -p /app/src/main/resources/model
ENV APP_HOME=/app/
WORKDIR $APP_HOME
# Copy the built application to the container
COPY build/libs/*.jar /app/app.jar
COPY src/main/resources/model /app/src/main/resources/model
# Expose port 8080
EXPOSE 8080
# Run the application
ENTRYPOINT ["java","-XX:NativeMemoryTracking=detail", "-jar", "/app/app.jar"]