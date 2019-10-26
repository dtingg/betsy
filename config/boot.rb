ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

if ENV['ENABLE_CODE_COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
