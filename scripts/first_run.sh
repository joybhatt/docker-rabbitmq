#!/bin/bash
USER=${RABBITMQ_USERNAME:-rabbitmq}
PASS=${RABBITMQ_PASSWORD:-$(pwgen -s -1 16)}
VHOST=${RABBITMQ_VHOST:-/}

#configure rabbitmq mnesia and log base dir
echo "Configuring base dir for mnesia and log as /data"
mkdir -p /data/rabbitmq/log
mkdir -p /data/rabbitmq/mnesia
chown -R rabbitmq:rabbitmq /data
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
cat > /etc/rabbitmq/rabbitmq-env.conf <<EOF
MNESIA_BASE=/data/rabbitmq/mnesia
LOG_BASE=/data/rabbitmq/log
EOF

# Create User
echo "Creating user: \"$USER\"..."
cat > /etc/rabbitmq/rabbitmq.config <<EOF
[
        {rabbit, [{default_user, <<"$USER">>},{default_pass, <<"$PASS">>},{default_vhost, <<"$VHOST">>},{tcp_listeners, [{"0.0.0.0", 5672}]},{vm_memory_high_watermark, {absolute, "196MiB"}},{log_levels, [{connection, info}, {channel, info}, {mirroring , info}]}]}
].
EOF

echo "========================================================================"
echo "RabbitMQ User: \"$USER\""
echo "RabbitMQ Password: \"$PASS\""
echo "RabbitMQ Virtual Host: \"$VHOST\""
echo "========================================================================"

rm -f /.firstrun
