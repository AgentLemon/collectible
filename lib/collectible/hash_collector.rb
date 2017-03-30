module Collectible
  class HashCollector < BaseCollector

    private

    def get_parser
      Parser::HashParser.new
    end
  end
end