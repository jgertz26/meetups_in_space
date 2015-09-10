require 'pry'
require 'rspec'
require 'capybara/rspec'
require 'database_cleaner'

require_relative '../app.rb'

set :environment, :test
set :database, :test

ActiveRecord::Base.logger = nil

Capybara.app = Sinatra::Application

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

OmniAuth.config.test_mode = true

def sign_in_as(user)
  mock_omni_auth_for(user)
  visit "/auth/#{user.provider}"
  expect(page).to have_content("You're now signed in as #{user.username}!")
end

def mock_omni_auth_for(user)
  mock_options = {
    uid: user.uid,
    provider: user.provider,
    info: {
      nickname: user.username,
      email: user.email,
      image: user.avatar_url
    }
  }
  OmniAuth.config.add_mock(user.provider.to_sym, mock_options)
end
