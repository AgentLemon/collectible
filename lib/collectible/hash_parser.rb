module Collectible
  class HashParser
    def initialize

    end

    def parse(schema, row)
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