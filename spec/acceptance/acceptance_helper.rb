require "spec_helper"

RSpec.configure do |config|
  Capybara.use_default_driver
  config.include Capybara, :type => :acceptance
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
