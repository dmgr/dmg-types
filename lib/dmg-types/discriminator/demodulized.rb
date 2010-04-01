require 'dm-core'
require "#{File.dirname(__FILE__)}/common.rb"

module DataMapper
  module Types
    class DemodulizedDiscriminator < CommonDiscriminator
      primitive String
      default   lambda { |resource, property| resource.model }
      required  true
      
      def self.dump(value, property)
        ActiveSupport::Inflector.demodulize(value)
      end
    end
  end # module Types
end # module DataMapper