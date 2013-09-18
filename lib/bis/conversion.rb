class Bis
  module Conversion
    def Bis(obj)
      if obj.kind_of? Bis
        obj
      elsif obj.kind_of? Enumerable
        Bis.from_enum(obj)
      elsif obj.respond_to? :to_i
        Bis.new(64, value: obj.to_i)
      else
        fail TypeError, "#{obj.class} can't be coerced to Bis"
      end
    end
  end
end

module Kernel
  include Bis::Conversion
end
