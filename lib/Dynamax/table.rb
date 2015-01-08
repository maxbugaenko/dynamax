class Table
  class_attribute :config
  include Methods

  def initialize(val)
    @key_value = val
    Dynamax.logger.debug("#{self.class.to_s} initialized. Config: #{config.to_s}")
  end

  def delete
    Dynamax.logger.warn("deleting item #{key[0].to_s} with value: #{@key_value.to_s}")
    Dynamax.aws.delete_item(
      table_name: self.table_name,
      key: key_string,
      return_values: 'ALL_OLD'
    )
    # what to return? if object is deleted - it no more exists
    self
  rescue => error
    # do we need to raise exception here?
    raise UknownField, "could not delete item: #{error.class}, #{error.message}"
    self
  end

  def create
    Dynamax.aws.put_item(
      table_name: self.table_name,
      item: key_string,
      return_values: 'ALL_OLD'
    )
    # if (new_id = res.data[:attributes][key[0].to_s][key[1]]) == @key_value
    Dynamax.logger.warn("New #{self.class.to_s} just created in database")
    self
  end

  def exists?
    found = Dynamax.aws.query(
      table_name: self.table_name,
      select: 'COUNT',
      scan_index_forward: false,
      key_conditions: {
        key[0].to_s => {
          attribute_value_list: [{ key[1].to_s => @key_value.to_s }],
          comparison_operator: 'EQ'
        }
      }
    )
    Dynamax.logger.debug("#{self.class.to_s} with key #{@key_value} exists in database")
    found[:count] > 0
  end

  private

  def key(which = :key)
    res = config.select do |option|
      option.include?(which)
    end
    raise Table::UknownField, "this table does not have field: #{which}" if !res || res.nil?
    Dynamax.logger.debug("Found field for #{self.class.to_s}. It is: #{res.first}")
    res.first
  end

  def key_string
    { key[0].to_s => { key[1].to_sym => @key_value.to_s } }
  end

  protected

  def update(param, value)
    Dynamax.logger.warn("updating item: #{param}. new value: #{value}")
    res = Dynamax.aws.update_item(
      table_name: self.table_name,
      key: key_string,
      attribute_updates: {
        param.to_s => {
          value: { key(:author)[1].to_sym => value },
          action: 'PUT'
        }
      },
      return_values: 'ALL_OLD'
    )
    # got to check if upate went ok
    self
  end

  def table_name
    "#{Dynamax.prefix}-#{self.class.to_s.downcase.pluralize}"
  end

  def item
    if @item.nil?
      @item = Dynamax.aws.get_item(
        table_name: table_name,
        consistent_read: false,
        key: key_string
      )[:item]
      if @item.nil?
        create
        @item = item
      end
    end
    @item
  end
end