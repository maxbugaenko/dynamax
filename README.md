# DynaMax DynamoDB Gem

## Purpose

Extremely easy to use Gem for DynamoDB based on official AWS-SDK.
Hope you enjoy this gem and you're welcome to contribute

## Install and use

```gem 'guppy', '~> 0.0.3'```

add this line to your Gemfile and then run

```bundle```


## Create config.yml file
DynamoDB credentials are read from YAML file that
should be in your app root directory. Here is a sample:

```
aws:
  access_key_id: 'AKIAIPW*******ZW4JDQ'
  secret_access_key: 'lF7Bgfwd4Y***************i4eo15RfUye/'
  dynamo_db_endpoint: 'dynamodb.us-east-1.amazonaws.com'
```

## Create table classes
Extend Dynamax::Table base class to get needed functionality
```
class Article < Table
  f [:id, :n, :key]
  f [:author, :s]
  f [:name, :s]
  f [:uri, :s]
end
```

Create such class for all tables you have created at DynamoDB
and add all fields to it.

## Usage
Here is a small simple Sinatra project with
some features demonstrated:

```
require 'sinatra'
require 'haml'
require 'yaml'
require 'dynamax'
require_relative 'lib/Article'

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

## DynamoDB Structure

Table `h12-articles` contains a full list of all articles:

```
id (hash): unique ID of the article
uri: URI of the article
tag: tag of it
place: position in rating, e.g. 3274
author: full name of the author, e.g. "Yegor Bugayenko"
title: title of the article
account: author's account, e.g. "yegor256"
votes: total number of votes received
```

And it has a few indexes:

```
places: (tag, place)
votes: (tag, votes)
unique (uri, id)
mine (account, id)
```

Table `h12-feeds` contains a full list of feeds:

```
uri (hash): unique URI of the RSS feed
user: twitter account name, for example "yegor256"
status: "live", "pending", "rejected"
message: text message explaining the latest event on this feed
```

And it has a few indexes:

```
mine: (user, uri)
```

Table `h12-users` has a full list of users:

```
name (hash): unique name of a user (twitter account, e.g. "yegor256")
points: total points available for this user
photo: binary photo of the author (PNG)
```

## Running H12 locally

In order to run the project locally do the following in the command line
```
bundle install
ruby h12.rb
```

