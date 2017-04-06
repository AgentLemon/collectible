module ActiveRecordStub
  class Association
    attr_reader :collection

    def initialize
      @collection = []
      @collection.instance_eval(%Q{
        def <<(value)
          fail("Item was added to association via << method!")
        end
        alias :push :<<
      })
    end

    def add_to_target(value)
      @collection += [value]
    end
  end
end
