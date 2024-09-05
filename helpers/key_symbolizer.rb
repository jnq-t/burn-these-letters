class KeySymbolizer
  def self.call(hash)
    raise "can only Symbolize hashes" unless hash.is_a?(Hash)
    hash.reduce({}) do |acc, (k,v)|
      key = k.respond_to?(:to_sym) ? k.to_sym : k
      acc.merge!(key => v)
      acc
    end
  end
end