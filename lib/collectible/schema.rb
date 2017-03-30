module Collectible
  class Schema
    attr_reader :klass, :identifier, :fields

    def initialize(klass, identifier, fields)
      @klass = klass
      @identifier = identifier
      @fields = fields
    end

    def get_id(entity)
      entity && (entity.respond_to?(identifier) ? entity.send(identifier) : entity[identifier])
    end

    def id_present?(entity)
      !id_blank?(entity)
    end

    def id_blank?(entity)
      id = get_id(entity)
      id.respond_to?(:empty?) ? !!id.empty? : !id
    end
  end
end