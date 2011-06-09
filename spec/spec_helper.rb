require 'spork'

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading
#   code that you don't normally modify during development in the
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#
Spork.prefork do
  # Loading more in this block will cause your specs to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    config.mock_with :rr
    # config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    config.use_instantiated_fixtures  = false
    config.include EmailSpec::Helpers
    config.include EmailSpec::Matchers
    config.include WardenHelperMethods

    config.global_fixtures = :ruby_kaigis

    #
    # == Notes
    #
    # For more information take a look at Spec::Runner::Configuration and Spec::Runner
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation, { :except => %w[ruby_kaigis] }
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:all) do
      Sham.reset(:before_all)
    end

    config.before(:each) do
      DatabaseCleaner.start
      Sham.reset(:before_each)

      begin
        Redis::Objects.redis.flushdb
      rescue Errno::ECONNREFUSED
        # Redis is not running.
      end
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end

  OmniAuth.config.test_mode = true
end

Spork.each_run do
  # This code will be run each time you run your specs.

end
