#mysql ダミーデータの作成
require 'bcrypt'
require 'mysql2'

def db
	return @db_client if defined?(@db_client)

	@db_client = Mysql2::Client.new(:host => '0.0.0.0', :username => 'root', :password => 'mysql')
end


#User
for i in 0...200 do
	name = sprintf("USER%03d",i)
	pass = BCrypt::Password.create("ABCD")

	query = "INSERT INTO latestgram.user (name, password) VALUES('#{name}', '#{pass}')"

	db.query(query)
end

#Article
for i in 0...100 do
	created_at = "2018-09-05"
	user_id = rand(100)
	good = rand(20)
	contents = "HOGE"

	query = "INSERT INTO latestgram.article (created_at, user_id, image, good, contents) VALUES('#{created_at}', #{user_id}, NULL, #{good}, '#{contents}')"

	db.query(query)
end

#Comment
for i in 0...150 do
	user_id = rand(200)
	article_id = rand(100)
	contents = "yes"

	query = "INSERT INTO latestgram.comment (user_id, article_id, contents) VALUES(#{user_id}, #{article_id}, '#{contents}')"

	db.query(query)
end
