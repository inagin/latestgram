require 'sinatra'
require 'sinatra/reloader'
require 'mysql2'


private
def db
	return @db_client if defined?(@db_client)

	@db_client = Mysql2::Client.new(:host => '0.0.0.0', :user => 'root', :password => 'mysql')
end

get '/' do
	@title = "latestgram - Top Page"
	@string = ""

	query = %q{SELECT name, created_at, image, good, contents FROM latestgram.article AS ar JOIN latestgram.user AS us ON ar.user_id = us.id}
	@results = db.query(query)
=begin
	results.each do |row|
		@string += "
		投稿者名: #{row['name']} <br />
		投稿日時: #{row['created_at']} <br />
		いいね #{row['good']} 件<br />
		#{row['contents']} <br />
		"
	end
=end
	erb :index

end
