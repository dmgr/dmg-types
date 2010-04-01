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
        model           = property.model
        property_name   = property.name
        repository_name = property.repository_name
        
        model.discriminator = Discriminator.new(property)

        model.class_eval <<-RUBY, __FILE__, __LINE__+1
          extend Chainable
          
          extendable do
            def inherited(model)
              super  # setup self.descendants
              model.default_scope(#{repository_name.inspect}).update(#{property_name.inspect} => model.descendants)
            end
          end
        RUBY
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