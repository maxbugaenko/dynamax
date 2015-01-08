require 'sinatra'
require 'haml'
require_relative 'lib/Dynamax/dynamax'
require_relative 'lib/proof/Article'

Dynamax::Config.new('h12', 'config.yml', Logger::DEBUG)

get '/' do
  art = Article.new(12388).delete
  if art.exists?
    'AUTHOR NOW:' + art.author
    art.author('maxic').delete
  end
  # art = art.author
  'Dynamax PoC'
end