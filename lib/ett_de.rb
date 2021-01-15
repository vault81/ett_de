module EttDe; end

module DeepSymbolizable
  def deep_symbolize(&block)
    method = self.class.to_s.downcase.to_sym
    syms = DeepSymbolizable::Symbolizers
    syms.respond_to?(method) ? syms.send(method, self, &block) : self
  end

  module Symbolizers
    extend self

    def hash(hash, &block)
      hash.inject({}) do |result, (key, value)|
        value = _recurse_(value, &block)

        key = yield key if block_given?
        sym_key =
          begin
            key.to_sym
          rescue StandardError
            key
          end

        result[sym_key] = value
        result
      end
    end

    def array(ary, &block)
      ary.map { |v| _recurse_(v, &block) }
    end

    def _recurse_(value, &block)
      if value.is_a?(Enumerable) && !value.is_a?(String)
        unless value.class.include?(DeepSymbolizable)
          value.extend DeepSymbolizable
        end
        value = value.deep_symbolize(&block)
      end
      value
    end
  end
end

class Hash
  include DeepSymbolizable
end
