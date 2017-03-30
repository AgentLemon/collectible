module Collectible
  module Parser
    class HashParser < BaseParser
      def parse(schema, row)
        get_fields_hash(schema, row)
      end
    end
  end
end