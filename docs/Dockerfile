FROM ubuntu:24.04
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:21-jdk-noble $JAVA_HOME $JAVA_HOME
COPY --from=eclipse-temurin:8-jdk-noble $JAVA_HOME /opt/java/openjdk8
ENV ORIG_PATH="${PATH}"
ENV PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
WORKDIR /home
RUN apt-get update && apt-get install -y git build-essential python3 bc
RUN git clone --branch bisim https://github.com/zfatmi13/prism.git && git clone https://github.com/zfatmi13/benchmarks.git
WORKDIR /home/prism/prism
RUN make
WORKDIR /home/jpf
RUN git clone --branch java-8 https://github.com/javapathfinder/jpf-core.git && git clone https://github.com/javapathfinder/jpf-probabilistic.git && git clone https://github.com/javapathfinder/jpf-label.git
ENV JAVA_HOME=/opt/java/openjdk8
ENV PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
WORKDIR /home/jpf/jpf-core
RUN ./gradlew buildJars
WORKDIR /root/.jpf
RUN printf "jpf-core = /home/jpf/jpf-core\njpf-label = /home/jpf/jpf-label\njpf-probabilistic = /home/jpf/jpf-probabilistic\n" >> site.properties
WORKDIR /home/jpf/jpf-label
RUN ./gradlew buildJars
WORKDIR /home/jpf/jpf-probabilistic
RUN ./gradlew buildJars
WORKDIR /home/benchmarks/jpf/jpf_files
RUN javac -g probabilistic/*.java *.java
ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="${JAVA_HOME}/bin:${ORIG_PATH}"
ENV PRISM_JAVAMAXMEM=8g
WORKDIR /home
COPY benchmarks/docs/* .
COPY benchmarks/scripts/* .
