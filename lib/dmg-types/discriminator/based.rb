require 'dm-core'
require "#{File.dirname(__FILE__)}/common.rb"

module DataMapper
  module Types
    class BasedDiscriminator < CommonDiscriminator
      primitive String
      default   lambda { |resource, property| resource.model }
      required  true
      
      def self.dump(value, property)
        value.to_s.gsub(/^#{property.model}:*/, '')
      end
    end
  end # module Types
end # module DataMapper