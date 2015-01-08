class Error < Exception
  def raise
    Dynamax.logger.fatal("DYNAMAX ERROR: #{self.message}")
    super
  end
end
class UknownField < Error; end
class NoAWSConfig < Error; end
