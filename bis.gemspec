# encoding: utf-8

$LOAD_PATH.unshift 'lib'

require 'bis/version'

Gem::Specification.new do |s|
  s.name              = 'bis'
  s.version           = Bis::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = 'Pure ruby bitset implementation'
  s.homepage          = 'http://github.com/fuadsaud/bis'
  s.email             = 'fuadksd@gmail.com'
  s.authors           = 'Fuad Saud'
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE.md )
  s.files            += Dir.glob('lib/**/*')
  s.files            += Dir.glob('spec/**/*')

  s.description       = <<-DESC
  Feed me.
DESC

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
end
