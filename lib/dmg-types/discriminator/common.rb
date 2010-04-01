require 'dm-core'

module DataMapper
  module Types
    class CommonDiscriminator < Discriminator
      def self.dump(value, property)
        raise 'implement'
      end
      
      def self.load(value, property)
        property.model.find_const(value)
      end

      def self.bind(property)
        property.model.discriminator = Discriminator.new(property)
      end
      
      class Discriminator < Model::DiscriminatorAdapter
        def initialize(property)
          super()
          @property = property
        end
        
        def discriminate(record, bag)
          case klass = record[@property]
            when Class then klass
            else @property.type.load(klass.to_s, @property)
          end
        end
      end
    end
  end # module Types
end # module DataMapper