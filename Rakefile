require 'rubygems'
require 'rake'

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dmg-types'
    gem.summary     = 'DataMapper plugin providing extra data types'
    gem.description = gem.summary
    gem.email       = 'dmg [a] dmg [d] pl'
    gem.homepage    = 'http://github.com/dmgr/%s/tree/master' % gem.name
    gem.authors     = [ 'Dawid Marcin Grzesiak' ]

    gem.rubyforge_project = 'datamapper'

    gem.add_dependency 'dm-core',                     '~> 0.10.3'

    gem.add_development_dependency 'rspec',           '~> 1.3'
    gem.add_development_dependency 'yard',            '~> 0.5'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
