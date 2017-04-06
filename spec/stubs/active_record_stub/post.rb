module ActiveRecordStub
  class Post < Base
    attr_accessor :id, :text

    has_many :attachments
  end
end
