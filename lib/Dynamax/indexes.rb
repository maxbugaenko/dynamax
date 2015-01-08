module Indexes
  extend ActiveSupport::Concern
  module ClassMethods
    def i(options)
      self.indexes = [] if self.indexes.nil?
      self.indexes.push(options)
    end
    extend ClassMethods
  end
end
