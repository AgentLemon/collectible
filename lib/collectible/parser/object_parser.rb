module Collectible
  module Parser
    class ObjectParser < BaseParser
      def parse(schema, row)
        fields = get_fields_hash(schema, row)
        schema.klass.new(fields) if fields
      end
    end
  end
end
