require 'bunny'

def missed_message?(received_messages, new_message)
  last_message = received_messages.last
  return false unless last_message

  last_message + 1 != new_message
end

def setup_ch
  conn = Bunny.new("amqp://guest:guest@192.168.99.106")
  conn.start

  conn.create_channel
end

def setup_queue(ch)
  q = ch.queue("message_queue", :durable => true)
  q
end

def subscribe(q, ch)
  received_messages = []
  missed_counter = 0

  q.subscribe(:manual_ack => true, :block => true) do |delivery_info, properties, body|
    puts " [x] Received #{body}"

    missed_counter += 1 if missed_message?(received_messages, body.to_i)

    received_messages << body.to_i

    missed_percent = (missed_counter / received_messages.count.to_f) * 100
    puts "Missed: #{missed_counter} (#{missed_percent.floor}%)"

    ch.ack(delivery_info.delivery_tag)
  end
end


begin
  ch = setup_ch
  q  = setup_queue(ch)
  puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"

  subscribe(q, ch)
rescue Bunny::Session => be
  puts "Bunny::Session!!!!"
rescue Interrupt => _
  conn.close
end

puts "Game Over!"
