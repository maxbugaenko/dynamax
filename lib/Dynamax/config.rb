module Dynamax
  class Config
    def initialize(prefix, conf, level)
      Dynamax::Logging.new(level)
      Dynamax.prefix = prefix
      creds = YAML.load(File.open(conf))
      AWS.config(
        access_key_id: creds['aws']['access_key_id'],
        secret_access_key: creds['aws']['secret_access_key'],
        dynamo_db_endpoint: creds['aws']['dynamo_db_endpoint']
      )
      AWS.config.credentials
      raise NoConfigFile, 'Sad, but your config.yml file does not exist' unless !creds.nil?
      Dynamax.aws = AWS::DynamoDB::Client::V20120810.new
      Dynamax.logger.debug("DynaMax Gem. Have fun :)")
      Dynamax.logger.debug("http://github.com/maxbugaenko/dynamax")
      Dynamax.logger.debug("email: max.bugaenko@gmail.com")
      Dynamax.logger.debug("January 2015")
      Dynamax.logger.info("Connected to AWS DynamoDB")
      Dynamax.logger.info("credentials: #{creds['aws']['access_key_id']}")
      Dynamax.logger.info("prefix: #{prefix}")
    rescue AWS::Errors::MissingCredentialsError
      Dynamax.logger.fatal('Could not connect to AWS DynamoDB')
      raise NoAWSConfig, 'AWS Config is empty. Fix it and continue'
    rescue NoConfigFile => error
      Dynamax.logger.fatal(error.message)
      raise NoConfigFile, error.message
    end
  end

  class Logging
    def initialize(level = Logger::DEBUG)
      logger = Logger.new(STDOUT)
      logger.level = level
      logger.formatter = proc { |severity, _datetime, _progname, msg|
        "#{severity}: #{msg}\n"
      }
      Dynamax.logger = logger
    end
  end

  class << self
    attr_accessor :aws
    attr_accessor :prefix
    attr_accessor :logger
  end
end