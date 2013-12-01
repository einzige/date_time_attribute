if ENV['COVERALLS_CONFIG'] != 'nocoveralls'
  require 'coveralls'
  Coveralls.wear!
end

require 'date_time_attribute'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.formatter = :documentation
end
