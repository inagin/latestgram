require 'bcrypt'
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

	query = %q{SELECT name, created_at, image, good, contents FROM latestgram.article AS ar JOIN latestgram.user AS us ON ar.user_id = us.id}
	@results = db.query(query)

	erb :index
end

get '/signup' do
	@title = "latestgram - Sign Up"

	erb :signup
end

post '/signup_confirm' do
	name = params[:name]
	pass = BCrypt::Password.create(params[:password])

	query = "SELECT * FROM latestgram.user AS us WHERE us.name = '#{name}'"
	
	#名前が空 or パスワードが空
	if(name == nil || pass == nil) then
		redirect '/signup'
	end

	#名前が重複している
	if(db.query(query).count > 0) then
		#エラー
		redirect '/signup'
	end

	query = "INSERT INTO latestgram.user (name, password) VALUES('#{name}', '#{pass}')"
	
	#インジェクション対策
	statement = db.prepare(query)
	statement.execute()

	redirect '/'
end