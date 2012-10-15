# post_message.rb

require "net/http"

puts ""
print "Who do you want to message? "
name = gets.chomp

print "Your message: "
message = gets.chomp

puts ""
print "Sending message..."

uri = URI("http://#{name}-messages.herokuapp.com")

# TODO: Post the message to the server

res = Net::HTTP.post_form(uri, "message" => message)

puts "done!"
puts "Result: #{res.body}"

puts ""
