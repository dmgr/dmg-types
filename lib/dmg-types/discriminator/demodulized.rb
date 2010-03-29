require 'dm-core'

module DataMapper
  module Types
    class DemodulizedDiscriminator < Discriminator
      primitive String
      default   lambda { |resource, property| resource.model }
      required  true
      
      def self.dump(value, property)
        ActiveSupport::Inflector.demodulize(value)
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
    end # class DemodulizedDiscriminator
  end # module Types
end # module DataMapper
