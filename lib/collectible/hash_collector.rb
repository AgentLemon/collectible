module Collectible
  class HashCollector < BaseCollector

    private

    def get_parser
      Parser::HashParser.new
    end

    def add_to_entity_collection(entity, key, item)
      entity_collection(entity, key) << item
    end
  end
end