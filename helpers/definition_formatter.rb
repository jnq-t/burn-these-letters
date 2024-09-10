class DefinitionFormatter
  def self.call(definition)
    @definition = definition
    return definition.to_sym if definition.respond_to?(:to_sym)
    raise "object can't be symbolized" unless definition.is_a?(Hash)
    return definition if self.correctly_formatted?

    formatted_keys_def = definition.reduce({}) do |acc, (k,v)|
      key = k.respond_to?(:to_sym) ? k.to_sym : k
      value = v.is_a?(String) ? [v] : v
      acc.merge!(key => value)
      acc
    end
    # formatted_keys_def.map do |k,v|
    #   value = v.is_a?(String) ? [v] : v
    #   [k,value]
    # end
  end

private

  def self.correctly_formatted?
    @definition.keys.each do |key|
      return unless key.is_a? Symbol
    end
    @definition.values.each do |value|
      return false unless value.is_a? Array
    end
    true
  end
end