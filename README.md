# DynaMax DynamoDB Gem

This is an easy to use ```gem``` for DynamoDB based on official ```aws-sdk```.
Hope you enjoy this gem and you're welcome to contribute. Developed for Sinatra

## Install and use

```gem 'dynamax', '~> 0.0.3'```

add this line to your Gemfile and then run

```bundle install```


## Create config.yml file
DynamoDB credentials are read from YAML file. You can place
it wherever you want. Please do not save it in your public directory.
Here is a sample of config.yml

```
aws:
  access_key_id: 'AKIAIPW*******ZW4JDQ'
  secret_access_key: 'lF7Bgfwd4Y***************i4eo15RfUye/'
  dynamo_db_endpoint: 'dynamodb.us-east-1.amazonaws.com'
stateful:
  urn: 'urn:facebook:9*********7879'
  token: '88A5-****-****-18DE'
```

## Create table classes
Extend Dynamax::Table base class to get needed functionality for
each table.

```
class Article < Table
  f [:id, :n, :key]
  f [:author, :s]
  f [:name, :s]
  f [:uri, :s]
end
```

## Usage
Here is a simple Sinatra project with some features
demonstrated:

```
require 'sinatra'
require 'haml'
require 'dynamax'
require_relative 'lib/Article'
require_relative 'lib/Articles'

Dynamax::Config.new('h12', 'config.yml', Logger::DEBUG)

get '/' do
  # this creates new row in Dynamo
  # either you can specify key value explicitly
  # or you can use Stateful.co to retrieve
  # unique integer key value. Read about Stateful.co
  # further
  article = Article.new(Dynamax::USE_STATEFUL).create
  # we check if article actually exists
  if article.exists?
    # access any attribute or change it by calling corresponding
    # methods from your table classes
    puts "article author: #{article.author}"
    # change value for the attribute author just
    # like that
    art.author('maxic')
    # article.delete would delete row from the table
  end
end
```

## Create single record
Actually there's more than one way to create one record. Here
you go

```
article = Article.new
# this will just create instance of Article class
# with no data at all. Physically you wont see any changes
# in database. However this would be fully working
# instance of piece of data. Next you can do the following
# for example:
article.author('John Smith')
article.link('http://myblog.com')
# this would actually apply specified data to the
# our just initialized instance of Article
```

## Queries and lists
To fetch some data from DynamoDB we all have just one
option. It is ```aws.query``` method. Here is another
example of how to query Dynamo.
```
articles = Articles.new
list = articles
  .index(:unique)
  .where(uri: 'http://myblog.com')
  .where('id > 1000')
  .limit(10)
```
now we can iterate through this ```list``` and get
our ```Article``` instances like described above. We
can do something like:

```
list.each do |article|
    article.author('John') if article.id > 10
end
```
