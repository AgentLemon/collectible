module ActiveRecordStub
  class Base
    def self.has_many(field)
      self.class_eval %Q{
        associations << :#{ field }
        attr_accessor :#{ field }

        def #{ field }
          @#{ field }.collection
        end

        def #{ field }=(value)
          fail("Field #{ field } was set with = method!") if id
        end
      }
    end

    def self.associations
      @has_many_fields ||= []
    end

    def self.reflect_on_all_associations(_type)
      self.associations
    end

    def self.primary_key
      "id"
    end

    def initialize(params = {})
      @errors = []
      self.class.associations.each { |field| instance_eval("@#{ field } = ActiveRecordStub::Association.new") }
      params.each { |field, value| self.send("#{ field }=", value) }
    end

    def association(field)
      instance_eval("@#{ field }")
    end
  end
end
