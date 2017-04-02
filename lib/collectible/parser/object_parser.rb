module Collectible
  module Parser
    class ObjectParser < BaseParser
      def parse(schema, row)
        fields = get_fields_hash(schema, row)
        id = filer_primary_key!(schema, fields)
        if fields
          entity = schema.klass.new(fields)
          entity.id = id if id
        end
        entity
      end

      private

      def filer_primary_key!(schema, fields)
        id_field = primary_key(schema)
        fields.delete(id_field.to_sym) if id_field
      end

      def primary_key(schema)
        schema.klass.primary_key if schema.klass.respond_to?(:primary_key)
      end
    end
  end
end
