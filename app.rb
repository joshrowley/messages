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
