# Copyright (c) 2011-2014, Dynamax
# All rights reserved.
require 'aws-sdk'
require 'active_support/all'
require_relative 'errors'
require_relative 'methods'
require_relative 'config'
require_relative 'table'
require_relative 'tables'

creds = YAML.load(File.open(
  File.join(File.dirname(__FILE__), '../../config.yml'))
)

AWS.config(
  access_key_id: creds['aws']['access_key_id'],
  secret_access_key: creds['aws']['secret_access_key'],
  dynamo_db_endpoint: creds['aws']['dynamo_db_endpoint']
)
Dynamax::Config.new('h12')
