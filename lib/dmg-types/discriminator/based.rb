require 'dm-core'

module DataMapper
  module Types
    class BasedDiscriminator < Discriminator
      primitive String
      default   lambda { |resource, property| resource.model }
      required  true
      
      def self.dump(value, property)
        value.to_s.gsub /^#{property.model}:*/, ''
      end
      
      def self.load(value, property)
        property.model.find_const(value)
      end
      
      def self.typecast(value, property)
        case value
          when Class then value
          else property.model.find_const(value.to_s)
        end
      end
    end
  end # module Types
end # module DataMapper
