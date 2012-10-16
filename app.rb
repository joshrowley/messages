# app.rb

require 'sinatra'
require 'json'
require 'data_mapper'
require 'net/http'

DataMapper.setup(:default, ENV['DATABASE_URL'])

get '/' do
  @messages = Message.all
  erb :messages
end

get '/reset' do
  DataMapper.auto_migrate!
  "Messages reset!"
end

get '/sendmessage' do
	erb :sendmessage
end

post '/sendmessage' do
	name = request.POST['name']
	message = request.POST['message']
  sender = request.POST['sender']
	uri = URI("http://#{name}-messages.herokuapp.com")
	res = Net::HTTP.post_form(uri, "message" => message,
                                  "sender" => sender)
	@name = name
	erb :sendmessage
end

post '/' do
  
  # TODO: Read the message contents, save to the database
  message_contents = request.POST['message']
  sender = request.POST['sender']



  # Creates links around any input that ends in .com
  words = message_contents.split
  links = words.map do |word|
  	word if word.end_with?(".com")
  end
  links.compact!

  links.each do |link|
  	if link.start_with?("http://")
  		message_contents[link] = "<a href=\"#{link}\">#{link}</a>"
  	else
  		message_contents[link] = "<a href=\"http://#{link}\">#{link}</a>"
  	end
  end

  # Creates img tags around any image

  imgs = words.map do |word|
  	if word.end_with?(".jpg") || word.end_with?(".gif") || word.end_with?(".png")
  		word
  	end
  end
  imgs.compact!

  imgs.each do |img|
  	if img.start_with?("http://")
  		message_contents[img] = "<img src=\"#{img}\">"
  	else
  		message_contents[img] = "<img src=\"http://#{img}\">"
  	end
  end


  @message_row = Message.new(:body => message_contents, 
  								:sender => sender)# add senders uri to db
  @message_row.save

  "Message posted!"
end

class Message
  
  # TODO: Use this class as a table in the database
  include DataMapper::Resource

  property :id, Serial # Auto-increment integer id
  property :body, Text # A longer text block
  property :created_at, DateTime # Auto assigns data/time
  property :sender, Text
  
end

DataMapper.finalize
