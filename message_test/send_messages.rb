require 'bunny'

conn = Bunny.new("amqp://guest:guest@192.168.99.106")
conn.start

ch = conn.create_channel
q = ch.queue("message_queue", :durable => true)

counter = 1
while counter < 300
  ch.default_exchange.publish("#{counter}", :routing_key => q.name)

  puts "sent: #{counter}"
  counter += 1
  sleep 0.1
end

conn.close
