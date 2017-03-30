module Collectible
  class HashCollector
    def initialize(schema)
      @schema = schema
      @parser = HashParser.new
      init_klasses
      init_entities
    end

    def collect(collection)
      collection.each do |row|
        collect_row(row)
      end
      root_entities.values
    end

    private

    def collect_row(row)
      collect_schema(@schema, row)
    end

    def collect_schema(schema, row)
      entity = @parser.parse(schema, row)

      if !entity.nil?
        @entities[schema.klass][schema.get_id(entity)] ||= entity
        entity = @entities[schema.klass][schema.get_id(entity)]

        schema.fields.each do |key, value|
          if value.is_a?(Schema)
            child = collect_schema(value, row)
            if schema.id_present?(child) && !entity[key].any?{ |i| value.get_id(i) == value.get_id(child) }
              entity[key] << child 
            end
          end
        end
      end

      entity
    end
    
    def init_klasses
      @klasses = []
      collect_klasses(@schema)
      @klasses.uniq!
      @root_klass = @klasses.first
    end

    def collect_klasses(schema)
      @klasses << schema.klass
      schema.fields.each do |key, value|
        collect_klasses(value) if value.is_a?(Schema)
      end
    end

    def init_entities
      @entities = {}
      @klasses.each do |klass|
        @entities[klass] = {}
      end
    end

    def root_entities
      @entities[@root_klass]
    end
  end
end