FROM frodenas/ubuntu
MAINTAINER Joy Bhattacharjee <joyahan01@gmail.com>

# Install RabbitMQ 3.6.5-1
RUN DEBIAN_FRONTEND=noninteractive && \
    cd /tmp && \
    wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc && \
    apt-key add rabbitmq-signing-key-public.asc && \
    echo "deb http://www.rabbitmq.com/debian/ testing main" | tee /etc/apt/sources.list.d/rabbitmq.list && \
    wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get -y install socat erlang-nox=1:19.3-1 && \
    apt-get install -y --force-yes rabbitmq-server=3.6.9-1 && \
    rabbitmq-plugins enable rabbitmq_management && \
    rabbitmq-plugins enable rabbitmq_jms_topic_exchange && \
    service rabbitmq-server stop && \
    apt-get install --yes runit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Expose our log volumes
VOLUME ["/data"]
