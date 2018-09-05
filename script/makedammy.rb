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
	created_at = sprintf("2018-09-%02d %02d:%02d:%02d", rand(1...31), rand(24), rand(60), rand(60))

	user_id = rand(100)
	good = rand(20)
	contents = "HOGE"

	query = "INSERT INTO latestgram.article (created_at, user_id, image, good, contents) VALUES('#{created_at}', #{user_id}, NULL, #{good}, '#{contents}')"

	db.query(query)
end

#Comment
for i in 0...150 do
	created_at = sprintf("2018-09-%02d %02d:%02d:%02d", rand(1...31), rand(24), rand(60), rand(60))

	user_id = rand(200)
	article_id = rand(100)
	contents = "yes"

	query = "INSERT INTO latestgram.comment (created_at, user_id, article_id, contents) VALUES('#{created_at}', #{user_id}, #{article_id}, '#{contents}')"

	db.query(query)
end
