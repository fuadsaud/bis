require 'rspec'

require_relative File.join(__dir__, '../lib/bis')

RSpec.configure do |config|
  config.include Bis::Conversion
end
