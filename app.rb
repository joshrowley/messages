# app.rb

require 'sinatra'
require 'json'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'])

get '/' do
  @messages = Message.all
  erb :messages
end

get '/reset' do
  DataMapper.auto_migrate!
  "Messages reset!"
end

post '/' do
  
  # TODO: Read the message contents, save to the database
  message_contents = request.POST['message']
  words = message_contents.split
  # Creates links around any input that ends in .com
  links = words.map do |word|
  	word if word.end_with?(".com")
  end
  links.compact!

  links.each do |link|
  	if link.start_with?("http://")
  		message_contents[link] = "<a href='#{link}'>#{link}</a>"
  	else
  		message_contents[link] = "<a href='http://#{link}'>#{link}</a>"
  	end
  end

  # Creates img tags around any image

  images = words.map do |word|
  	if word.end_with?(".jpg") || word.end_with(".gif") || word.end_with(".png")
  		word
  	end
  end
  images.compact!

  images.each do |image|
  	if image.start_with?("http://")
  		message_contents[image] = "<img src='http://#{image}'>"
  	else
  		message_contents[image] = "<img src='#{image}'>"
  	end
  end


  @message_row = Message.new(:body => message_contents)
  @message_row.save

  "Message posted!"
end

class Message
  
  # TODO: Use this class as a table in the database
  include DataMapper::Resource

  property :id, Serial # Auto-increment integer id
  property :body, Text # A longer text block
  property :created_at, DateTime # Auto assigns data/time
  
end

DataMapper.finalize
