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

	erb :index

end
