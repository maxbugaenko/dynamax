module Dynamax
  class Tables
    def initialize(name)
      @name = name
    end

    def get(identificator)
      Table.new(identificator)
    end
  end
end