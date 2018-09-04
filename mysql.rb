require 'mysql2'

client = Mysql2::Client.new(:host => '0.0.0.0', :username => 'root', :password => 'mysql')

query = %q{select created_at, image, good, contents from latestgram.article}
results = client.query(query)

puts query
puts results

results.each do |x|
	puts x["good"]
end