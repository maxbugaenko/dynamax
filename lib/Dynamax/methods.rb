module Methods
  extend ActiveSupport::Concern
  module ClassMethods
    def f(options)
      self.config = [] if self.config.nil?
      self.config.push(options)
      define_method options[0].to_sym do |value = nil|
        if value.nil?
          item = self.item()
          return 'unknown' if item.nil? || item[options[0].to_s].nil?
          Dynamax.logger.debug("Sucessfully found item attribute: #{option[0].to_s}")
          item[options[0].to_s][options[1].to_sym]
        else
          Dynamax.logger.debug("Updating attribute value to: #{value}")
          return self.update(options[0], value)
        end
      end
    end
    extend ClassMethods
  end
end
