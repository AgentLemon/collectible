module Collectible
  class ObjectCollector < BaseCollector

    private

    def get_parser
      Parser::ObjectParser.new
    end

    def add_to_entity_collection(entity, key, item)
      if active_record_relation?(entity, key)
        entity.association(key).add_to_target(item)
      else
        entity_collection(entity, key) << item
      end
    end

    def active_record_relation?(entity, key)
      klass = entity.class
      klass.respond_to?(:reflect_on_all_associations) && klass.reflect_on_all_associations(:has_many).include?(key)
    end
  end
end