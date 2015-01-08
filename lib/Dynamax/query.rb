module Dynamax
  class Query
    @options = {}

    def initialize
      @options ||= {}
    end

    def index(index)
      @index = index
      self
    end

    def where(field_value, _type = :s, _condition = 'EQ')
      unless field_value.instance_of?(String)
        @options.merge!(
          field_value.keys[0].to_s => {
            attribute_value_list: [{ _type => field_value.values[0].to_s }],
            comparison_operator: _condition
          }
        )
      else
        field, condition, value = parse_criteria(field_value)
        @options.merge!(
          field.to_s => {
            attribute_value_list: [{ _type => value }],
            comparison_operator: condition
          }
        )
      end
      self
    end

    def limit(limit)
      @limit = limit
      self
    end

    def each(&block)
      result = make_query
      # puts 'RESULT: ' + result.to_s
      # puts 'COUUNT: ' + result.count.to_s
      # list = Array.new
      result.each do |item|
        puts 'ACC: ' + item['account'][:s]
        yield get(item[table_hash_key[:key]][table_hash_key[:type]])
      end
      # list.each(&block)
    end

    private

    def parse_criteria(criteria)
      # have got issue
      # bad things here
      crits = criteria.split(' ')
      case crits[1]
        when '<'
          [crits[0], 'LT', crits[2]]
        when '>'
          [crits[0], 'GT', crits[2]]
        when '='
          [crits[0], 'EQ', crits[2]]
      end
    end

    def make_query
      # puts 'OPTIONS: ' + @options.to_s
      # puts 'PARENT: ' + self.table_name
      Dynamax.aws.query(
        table_name: self.table_name,
        index_name: @index.to_s,
        select: 'ALL_ATTRIBUTES',
        scan_index_forward: false,
        limit: @limit,
        consistent_read: false,
        key_conditions: @options
      ).member
    end
  end
end