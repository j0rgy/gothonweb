require_relative "gothonweb/version"
require_relative "map"
require "sinatra"
require "haml"

use Rack::Session::Pool

get '/' do
  # this is used to "setup" the session with starting values
  p START
  session[:room] = START
  redirect("/game")
end  

get '/game' do
  if session[:room]
    haml :show_room, :locals => {:room => session[:room]}
  else
    # why is this here? do you need it?
    haml :you_died
  end
end

post '/game' do
  action = "#{params[:action] || nil }"
  # there is a bug here, can you find it?
  if session[:room]
    session[:room] = session[:room].go(params[:action])
  end
  redirect("/game")
end


#post '/hello' do
#	greeting = "#{params[:greet] || "Hello"}, #{params[:name] || "Nobody"}"
#
# if params['myfile']
#		File.open('uploads/' + params['myfile'][:filename], "w") do |f|
#			f.write(params['myfile'][:tempfile].read)
#	  end
#	  message = "The file '#{params['myfile'][:filename]}' was successfully uploaded!"
#	else
#		message = "There was no file uploaded."
#	end
#
#	haml :index, :locals => {:greeting => greeting, :message => message}
#end