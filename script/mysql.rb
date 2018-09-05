require 'mysql2'
require 'bcrypt'

client = Mysql2::Client.new(:host => '0.0.0.0', :username => 'root', :password => 'mysql')

name = "test"
pass = BCrypt::Password.create("test")


query = "select * from latestgram.user where name = 'test'"
result = client.query(query)
p result.count()