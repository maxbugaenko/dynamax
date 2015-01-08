class Tables < Dynamax::Query
  def get(key)
    puts 'HASSS KEY: ' + table_hash_key.to_s
    abort
    instance_eval do
      table_name.singularize.class.new(key)
    end
  end

  def query(index, options, limit)
    conditions = {}
    options.each do |option, value, type, _condition = 'EQ'|
      conditions.merge!(
        option.to_s => {
          attribute_value_list: [{ type.to_sym => value }],
          comparison_operator: condition
        }
      )
    end
    result = Dynamax.aws.query(
      table_name: self.table_name,
      index_name: index[:index],
      select: 'ALL_ATTRIBUTES',
      scan_index_forward: false,
      limit: limit,
      consistent_read: false,
      key_conditions: conditions
    ).member
    list = Array.new
    result.each do |item|
      list.push(get(item[table_hash_key[:key]][table_hash_key[:type]]))
    end
    list
  end

  protected

  def table_name
    "#{Dynamax.prefix}-#{self.class.to_s.downcase.pluralize}"
  end

  def table_hash_key
    resp = Dynamax.aws.describe_table(
      table_name: self.table_name,
    )
    puts resp.data.to_a.to_s
  end


end