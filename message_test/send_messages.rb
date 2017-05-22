require 'bunny'

def success?(ch)
  success = ch.wait_for_confirms

  if !success
    ch.nacked_set.each do |n|
      puts "nacked: #{n.inspect}"
    end
  end

  success
end

def rabbitmq_send
  conn = Bunny.new("amqp://guest:guest@192.168.99.100")
  conn.start

  ch = conn.create_channel

  ch.confirm_select unless ch.using_publisher_confirmations?
  q = ch.queue("message_queue", :durable => true)

  counter = 1
  while counter < 300
    ch.default_exchange.publish("#{counter}", :routing_key => q.name)

    puts "sent: #{counter}"
    counter += 1

    raise "not all messages acked!" unless success?(ch)

    sleep 0.1
  end

  sleep 0.2
  puts "Processed all published messages. #{q.name} now has #{q.message_count} messages."

  conn.close
rescue Exception => e
  puts "Rescued from #{e.inspect}, resending messages..."
  sleep 5
  rabbitmq_send
end

rabbitmq_send
