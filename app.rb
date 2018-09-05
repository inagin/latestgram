require 'bcrypt'
require 'sinatra'
require 'sinatra/reloader'
require 'mysql2'
require 'sinatra/flash'

enable :sessions

private
def db
	return @db_client if defined?(@db_client)

	@db_client = Mysql2::Client.new(:host => '0.0.0.0', :user => 'root', :password => 'mysql')
end


get '/' do
	@title = "latestgram - Top Page"

	query = %q{SELECT name, created_at, image, good, contents FROM latestgram.article AS ar JOIN latestgram.user AS us ON ar.user_id = us.id LIMIT 50}
	@results = db.query(query)

	erb :index
end

get '/signup' do
	@title = "latestgram - Sign Up"

	erb :signup
end

post '/signup_confirm' do
	name = params[:name]

	#名前が空 or パスワードが空
	if(name.empty? || params[:password].empty?) then
		flash[:notice] = "名前とパスワードを入力してください"
		redirect "/signup"
	end

	pass = BCrypt::Password.create(params[:password])

	query = "SELECT * FROM latestgram.user AS us WHERE us.name = ?"
	statement = db.prepare(query)
	result = statement.execute(name)	

	#名前が重複している
	if(result.count > 0) then
		#エラー
		flash[:notice] = "その名前は登録できません"
		redirect "/signup"
	end

	query = "INSERT INTO latestgram.user (name, password) VALUES(? , ?)"
	
	statement = db.prepare(query)
	statement.execute(name, pass)

	flash[:notice] = "ユーザー登録が完了しました"
	redirect '/'
end
