module Dynamax
  class Records

    def add(item)
      @items ||= []
      @items.push(item)
    end

    def each
      @items.each do |item|
        yield Dynamax::Item.new(item, @document)
      end
    end

    def document_info
      resp = Dynamax.aws.describe_table(
        table_name: @document,
      )
      puts resp.data.to_a.to_s
    end

  end

  class Item < AWS::Core::Data
    @data ||= {}

    def initialize(data, document)
      @data = data
      @document = document
    end

    def get(field)
      @data[field].first.last.to_s
    end

    def set(field, value)
      update(field, value)
    end

    private

    def determine_type(var)
      types = {
        :fixnum => :n,
        :string => :s,
        :set => :ss
      }
      types.each do |type, amazon_type|
        return amazon_type if var.instance_of?(type)
      end
      false
    end

    def update(param, value)
      Dynamax.logger.warn("updating item: #{param}. new value: #{value}")
      Dynamax.aws.update_item(
        table_name: @document,
        key: key_string,
        attribute_updates: {
          param.to_s => {
            value: { determine_type(value) => value },
            action: 'PUT'
          }
        },
        return_values: 'ALL_OLD'
      )
      # got to check if upate went ok
      self
    end

    def key_string
      {
        parent.document_info(:key_name) => {
          parent.document_info(:key_type) => parent.document_info(:key_value).to_s
        }
      }
    end

  end
end