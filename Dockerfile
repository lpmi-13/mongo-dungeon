FROM mongo:3.6.23-xenial

RUN apt update && apt install -y wget \
  && wget https://github.com/percona/mongodb_exporter/releases/download/v0.7.1/mongodb_exporter-0.7.1.linux-amd64.tar.gz \
  && tar xvzf mongodb_exporter-0.7.1.linux-amd64.tar.gz

RUN useradd -rs /bin/false prometheus \
  && mv mongodb_exporter /usr/local/bin/

EXPOSE 27017

ENTRYPOINT ["/usr/bin/mongod"]
