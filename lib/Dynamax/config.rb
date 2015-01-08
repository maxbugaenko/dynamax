require 'logger'
module Dynamax
  class Config
    def initialize(prefix)
      AWS.config.credentials
      Dynamax.aws = AWS::DynamoDB::Client::V20120810.new
      Dynamax::Logging.new
      Dynamax.prefix = prefix
      Dynamax.logger.debug("DynaMax Gem. Have fun :)")
      Dynamax.logger.debug("http://github.com/maxbugaenko/dynamax")
      Dynamax.logger.debug("email: max.bugaenko@gmail.com")
      Dynamax.logger.debug("January 2015")
      Dynamax.logger.info("Connected to AWS DynamoDB: #{Dynamax.aws}")
    rescue AWS::Errors::MissingCredentialsError
      Dynamax.logger.fatal('Could not connect to AWS DynamoDB')
      raise NoAWSConfig, 'AWS Config is empty. Fix it and continue'
    end
  end

  class Logging
    def initialize
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
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