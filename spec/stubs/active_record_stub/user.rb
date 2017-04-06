module ActiveRecordStub
  class User < Base
    attr_accessor :id, :name

    has_many :posts
  end
end
