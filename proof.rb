require 'sinatra'
require 'haml'
require 'yaml'
require_relative 'lib/Dynamax/dynamax'
require_relative 'lib/proof/Article'

get '/' do
  art = Article.new(12388).delete
  if art.exists?
    'AUTHOR NOW:' + art.author
    art.author('maxic').delete
  end
  # art = art.author
  'Dynamax PoC'
end