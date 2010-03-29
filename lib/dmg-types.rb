require 'dm-core'

module DataMapper
  module Types
    autoload :DemodulizedDiscriminator, 'dmg-types/discriminator/demodulized'
    autoload :BasedDiscriminator,       'dmg-types/discriminator/based'
  end
end
