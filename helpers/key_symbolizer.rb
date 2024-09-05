class KeySymbolizer
  def self.call(hash_or_key)
    return hash_or_key.to_sym if hash_or_key.respond_to?(:to_sym)
    raise "object canno't be symbolized" unless hash_or_key.is_a?(Hash)
    hash_or_key.reduce({}) do |acc, (k,v)|
      key = k.respond_to?(:to_sym) ? k.to_sym : k
      acc.merge!(key => v)
      acc
    end
  end
end