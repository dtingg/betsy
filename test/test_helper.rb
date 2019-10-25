require 'simplecov'


SimpleCov.start do
  add_filter "test/"
  add_filter "app/channels/"
  add_filter "apps/jobs/"
  add_filter "app/mailers/"
  add_filter "bin/spring"
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/reporters'



Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(merchant)
    return {
      provider: "github",
      uid: merchant.uid,
      info: {
        email: merchant.email,
        nickname: merchant.username
      }
    }
  end
  def perform_login(merchant = nil)
    merchant ||= Merchant.first
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(merchant))
    get auth_callback_path(:github)
    expect(session[:user_id]).must_equal merchant.id
    return merchant
  end
  # Add more helper methods to be used by all tests here...
end
