# DynaMax DynamoDB Gem

This is an easy to use ```gem``` for DynamoDB based on official ```aws-sdk```.
This gem pretty much relieves sufferings from ```aws-sdk``` :)
Hope you enjoy it and you're welcome to contribute. Developed for Sinatra

This gem contains most popular queries like ```put_item```, ```update_item```,
```query``` and others. All queries are method chains. A simple query will
like:

```
  @dynamax
    .document(:articles)
    .where(author: 'John Smith')
```
This would make a ```query``` and retrieve Dynamax::Records

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

## Get started
Create simple Sinatra project and require ```dynamax```. Add one
configuration line and you are ready to go. Here is all you
need to do to start

```
require 'sinatra'
require 'dynamax'

Dynamax::Config.new('h12', 'config.yml')
```
Global object ```dynamax``` will be initialized

### Queries
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

# lets find articles with specific
# votes count and change status
get '/downvote' do
  recs = @dynamax
    .document(:articles)
    .index(:votes)
    .where(tag: 'computers')
    .where('rating < 100')
    .update(
      votes: 0,
      tag: 'ineligible'
    )
end

get '/verify' do
  @dynamax
    .document(:articles)
    .index(:some_other_index)
    .where(:account => 'john_smith')
    .get
end
```

### Result of queries
Every query returns iterable ```Dynamax::Records``` instance
that contains array of ```Dynamax::Item```s that we just fetched