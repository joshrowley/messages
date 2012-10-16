# post_message.rb

require "net/http"

puts ""
print "Who do you want to message? "
name = gets.strip

print "Your message: "
message = gets.strip

print "From: "
sender = gets.strip

puts ""
print "Sending message..."

uri = URI("http://#{name}-messages.herokuapp.com")

res = Net::HTTP.post_form(uri, "message" => message, 
								"sender" => sender)

puts "done!"
puts "Result: #{res.body}"

puts ""
