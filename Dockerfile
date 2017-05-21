FROM rabbitmq:3.6.6-management

COPY start_rabbit.sh /start_rabbit.sh

CMD ["/start_rabbit.sh"]
