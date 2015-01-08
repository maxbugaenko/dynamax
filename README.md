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

## Basics
Create simple Sinatra project and require ```dynamax```. Add one
configuration line and you are ready to go. Here is all you
need to do to start

```
require 'sinatra'
require 'dynamax'

Dynamax::Config.new('h12', 'config.yml')
```

### Query chaining for data manipulation
Here are some Sinatra routes so we can see it in
real life

```
# lets add new article
get '/new' do
  @dynamax
    .document(:articles)
    .add(
      id: Stateful::Counter.new('article-counter').inc
      uri: 'http://rubyblog.com',
      account: 'John Smith',
      tag: 'computers',
      title: 'Some Ruby tricks'
    )
end

# lets update items by criteria
# here could be one and more items to update
get '/update' do
  @dynamax
    .document(:articles)
    .index(:votes)
    .where(:tag => 'computers')
    .where('votes < 100')
    .update(
      :votes => 0,
      :tag => 'ineligible'
    )
end
```
