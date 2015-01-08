require 'sinatra'
require 'haml'
require 'logger'
require_relative 'lib/Dynamax/dynamax'
require_relative 'lib/proof/Article'
require_relative 'lib/proof/Articles'

Dynamax::Config.new('h12', 'config.yml', Logger::DEBUG)

before do
  @articles = Articles.new
end

get '/' do
  list = @articles
    .index(:unique)
    .where(:uri => 'http://www.yegor256.com/2014/11/07/how-immutability-helps.html')
    .limit(10)
  haml
  list.each do |item|
    puts item
  end

  # # method QUERY fetches many records
  # @articles
  #   .query(:uri => 'http://www.search.com')
  #   .uri('http://www.anotherone.com')
  #
  # # fetches many records and then removes
  # # them all from the database
  # @articles
  #   .query(:uri => 'http://www.search.com')
  #   .delete
  #
  # # method GET fetches one record and returns
  # # self instance for chaining
  # @articles
  #   .get(:uri => 'http://www.search.com')
  #   .author('Bad Boy')
  #
  # # this would add new Article to
  # # the document and assign 109 as
  # # a hash key
  # @articles
  #   .add(
  #     Article
  #       .new(109)
  #       .author('Jean Claude Van-Damme'))
  #
  # # this would add new Article to
  # # the document and assign hash
  # # key from Stateful.co service.
  # # Check it at http://www.stateful.co
  # # If you need autoincrement values from
  # # time to time - this service is right for you
  # # and I have convenient module here in Gem to
  # # make your life easier
  # @articles
  #   .add(
  #     Article
  #       .new(Table::USE_STATEFUL)
  #       .uri('http://www.someuri.com')
  # )
  # # you can use Stateful by yourself if you want
  # # in this case you dont need to specify Table::USE_STATEFUL
  # # when initializing new Article
  # # you can use such code instead
  # # new_id = Stateful::Counter.new('article-counter').inc
  # # where 'article-counter' is my own identificator at
  # # Stateful. Enjoy ;)
  #
  #
  # if art.exists?
  #   'AUTHOR NOW:' + art.author
  #   art.author('maxic').delete
  # end
  # # art = art.author
  'Dynamax PoC'
end