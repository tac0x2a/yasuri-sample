# Author::    TAC (tac@tac42.net)

require 'sinatra'
require 'sinatra/reloader'

require 'slim'

before do
end

get '/' do
  slim :index
end
