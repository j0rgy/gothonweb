require_relative "gothonweb/version"
require "sinatra"
require "erb"
require "haml"

get '/' do
  greeting = "Yo, World!"
  erb :foo, :locals => {:greeting => greeting}
end  

#get '/hello' do
#	name = params[:name] || "Nobody"
#	greet = params[:greeting] || "Hi.."
#	greeting = "#{greet} #{name}"
#	erb :index, :locals => {:greeting => greeting}
#end

get '/hello' do
	haml :hello_form
end

post '/hello' do
	greeting = "#{params[:greet] || "Hello"}, #{params[:name] || "Nobody"}"

  if params['myfile']
		File.open('uploads/' + params['myfile'][:filename], "w") do |f|
			f.write(params['myfile'][:tempfile].read)
	  end
	  message = "The file '#{params['myfile'][:filename]}' was successfully uploaded!"
	else
		message = "There was no file uploaded."
	end

	haml :index, :locals => {:greeting => greeting, :message => message}
end