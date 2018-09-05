require 'bcrypt'
require 'sinatra'
require 'sinatra/reloader'
require 'mysql2'
require 'sinatra/flash'

set :sessions,
	secret: 'set_your_secret_key'

use Rack::Session::Cookie,
	secret: 'set_your_secret_key'

use Rack::Session::Pool,
	path: '/',
	domain: nil,
	expire_after: 60 * 10,
	secret: Digest::SHA256.hexdigest(rand.to_s)

private
def db
	return @db_client if defined?(@db_client)

	@db_client = Mysql2::Client.new(:host => '0.0.0.0', :user => 'root', :password => 'mysql')
end


get '/' do
	@title = "latestgram - Top Page"

	query = %q{SELECT ar.id, name, created_at, image, good, contents FROM latestgram.article AS ar JOIN latestgram.user AS us ON ar.user_id = us.id ORDER BY created_at DESC , ar.id DESC LIMIT 50}
	@results = db.query(query)

	@comments = []
	@comments_userid = []

	@results.each do |row|
		#Todo: ループクエリになっている
		#      commentから対応する3件のコメントを引っ張ってきた上で、そのコメントに対応するユーザー名も取得したい
		query = "SELECT id, created_at, contents FROM latestgram.comment AS co WHERE co.article_id = #{row['id']} ORDER BY co.created_at DESC, co.id DESC LIMIT 3"
	
		
		@comments.push( db.query(query) )
	end

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

get '/login' do
	@title = 'latestgram - Login'

	erb :login
end

post '/login' do
	name = params[:name]
	password = params[:password]

	if(name.empty? || password.empty?) then
		flash[:notice] = "名前とパスワードを入力してください"
		redirect "/login"
	end

	query = "SELECT id, name, password FROM latestgram.user WHERE name = ?"
	statement = db.prepare(query)
	result = statement.execute(name)	

	if(result.count == 0) then
		flash[:notice] = "名前かパスワードが違います"
		redirect "/login"
	end

	res = nil
	result.each do |row|
		res = row
	end
	if(BCrypt::Password.new(res['password']) == password) then
		#ログイン成功
		flash[:notice] = "#{name} としてログインしました"

		session[:user_id] = res['id'];
		redirect "/"
	end

	redirect "/login"
end