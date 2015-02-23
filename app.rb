# Author::    TAC (tac@tac42.net)

require 'sinatra'
require 'sinatra/reloader'

require 'slim'

require 'mechanize'
require 'json'
require 'yasuri'

set :server, 'webrick'

before do
  @url  = params[:url]  || "https://news.ycombinator.com/"
  @tree = params[:tree] || %Q|
{
  "node": "struct",
  "name": "titles",
  "path": "//td[@class='title'][not(@align)]",
  "children": [
    {
      "node": "text",
      "name": "title",
      "path": "./a"
    },
    {
      "node": "text",
      "name": "url",
      "path": "./a/@href"
    }
  ]
}
|
  @result = nil
  @tree = JSON.pretty_generate(JSON.load(@tree))
end

get '/' do
  slim :index
end

post '/' do
  begin
    tree  = Yasuri.json2tree(@tree)
    agent = Mechanize.new
    @page = agent.get(@url)
    @result = JSON.pretty_generate(tree.inject(agent, @page))
  rescue => e
    @exp = e.to_s
  end

  slim :index
end
