module Collectible
  module Parser
    class BaseParser
      def initialize

      end

      def parse(schema, row)
        fail "You must implement Parser::YourParser#parse method in your child class"
      end

      private

      def get_fields_hash(schema, row)
        entity = {}

        schema.fields.each do |key, value|
          if value.is_a?(Schema)
            entity[key] = []
          else
            entity[key] = row[value]
          end
        end

        entity if schema.id_present?(entity)
      end
    end
  end
end