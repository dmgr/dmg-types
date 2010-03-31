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
      
      def self.bind(property)
        property.model.discriminator = lambda do |record|
          case klass = record[property]
            when Class then klass
            else load(klass.to_s, property)
          end
        end
      end
    end # class DemodulizedDiscriminator
  end # module Types
end # module DataMapper
