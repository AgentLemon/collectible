module Collectible
  class ObjectCollector < BaseCollector

    private

    def get_parser
      Parser::ObjectParser.new
    end
  end
end