FROM srinivasachalla/docker-ubuntu
MAINTAINER Srinivasa Reddy Challa <srinivasa.challa@sap.com>


# Install wget, erlang 20.3 & RabbitMQ 3.7.4
RUN DEBIAN_FRONTEND=noninteractive && \
    cd /tmp && \
    apt-get update && \
    apt-get install wget && \
    wget https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc && \
    apt-key add rabbitmq-release-signing-key.asc && \
    echo "deb http://dl.bintray.com/rabbitmq/debian jessie rabbitmq-server-v3.7.x" | tee /etc/apt/sources.list.d/rabbitmq.list && \
    wget https://packages.erlang-solutions.com/ubuntu/erlang_solutions.asc && \
    apt-key add erlang_solutions.asc && \
    echo "deb http://packages.erlang-solutions.com/debian jessie contrib" | tee /etc/apt/sources.list.d/erlang.list && \
    apt-get update && \
    apt-get -y install esl-erlang=1:20.3 && \
    apt-get install -y --force-yes rabbitmq-server=3.7.4-1 && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_jms_topic_exchange && \
    rabbitmq-plugins enable rabbitmq_stomp && \
    rabbitmq-plugins enable rabbitmq_web_stomp && \
    service rabbitmq-server stop && \
    apt-get install --yes runit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## remove wget
RUN apt-get remove wget -y
# Add scripts
ADD scripts /scripts
RUN chmod +x /scripts/*.sh
RUN touch /.firstrun

# Command to run
ENTRYPOINT ["/scripts/run.sh"]
CMD [""]

# Expose listen port
EXPOSE 5672
EXPOSE 15672
EXPOSE 61613
EXPOSE 15674

# Expose our log volumes
VOLUME ["/data"]
