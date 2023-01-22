require 'sinatra'

get "/" do
  token = request.env['HTTP_X_CSRF_TOKEN']
  if token.to_s.strip.empty?
    "Didn't get a token"
  else
    "Hey here's your CSRF Token! #{token}"
  end
end
