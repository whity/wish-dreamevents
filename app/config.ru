require('sinatra')
require('app')

#global application configuration (sinatra)
disable(:run)
use(Rack::Session::DataMapper, :key => 'wde', :expire_after => 3600)
#use(Rack::Session::Pool, :key => 'wde', :expire_after => 3600)
use(Rack::Flash, :sweep => true)
use(Rack::Static, :urls => ["/public"])

# Mount our Main class with a base url of /
map("/") do
	run(WDE::Controllers::Main.new())
end

map("/blog") do
	run(WDE::Controllers::Blog.new())
end

#ADMIN
map("/admin") do
	run(WDE::Controllers::Admin::Main.new())
end

map("/admin/blog") do
	run(WDE::Controllers::Admin::Blog.new())
end