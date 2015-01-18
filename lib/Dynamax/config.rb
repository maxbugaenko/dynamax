module Dynamax
  class Config
    def initialize(prefix, conf, level)
      Dynamax.prefix = prefix
      Dynamax.creds = YAML.load(File.open(conf))
      AWS.config(
        logger: Logger.new('dynamologs.log'),
        log_level: :debug,
        access_key_id: Dynamax.creds['aws']['access_key_id'],
        secret_access_key: Dynamax.creds['aws']['secret_access_key'],
        dynamo_db_endpoint: Dynamax.creds['aws']['dynamo_db_endpoint']
      )
      Dynamax::Logging.new(level)
      AWS.config.credentials
      raise NoConfigFile, 'Sad, but your config.yml file does not exist' unless !Dynamax.creds.nil?
      Dynamax.aws = AWS::DynamoDB::Client::V20120810.new
      Dynamax.logger.debug("DynaMax Gem. Have fun :)")
      Dynamax.logger.debug("http://github.com/maxbugaenko/dynamax")
      Dynamax.logger.debug("email: max.bugaenko@gmail.com")
      Dynamax.logger.debug("January 2015")
      Dynamax.logger.info("Connected to AWS DynamoDB")
      Dynamax.logger.info("credentials: #{Dynamax.creds['aws']['access_key_id']}")
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
    attr_accessor :creds
  end
end