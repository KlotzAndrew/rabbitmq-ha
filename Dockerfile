FROM rabbitmq:3.6.6-management

COPY rabbitmq.config /etc/rabbitmq/rabbitmq.config
RUN chmod 777 /etc/rabbitmq/rabbitmq.config

COPY start_rabbit.sh /start_rabbit.sh

CMD ["/start_rabbit.sh"]
