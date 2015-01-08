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

    def document(table)
      @table = table
    end

    def add(hash)

    end

    def del

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

    def each
      make_query.each do |item|
        yield get(item[table_hash_key[:key]][table_hash_key[:type]])
      end
    end

    private

    # have got issue
    # bad things here
    def parse_criteria(criteria)
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