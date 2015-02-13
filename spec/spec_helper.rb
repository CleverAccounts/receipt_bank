require 'byebug'
require 'simplecov'
require 'receipt_bank'
require 'vcr'
require 'openssl'
require 'coveralls'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Coveralls.wear! if ENV.key?('COVERALLS_REPO_TOKEN')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
shared_context 'configuration' do
  let(:user_details) do
    { first_name: 'foo', last_name: 'bar',
      email: 'foo.bar@testuser.com', password: '11Password',
      currency: '', country: '',
      address_line_1: '', address_line_2: '',
      town: '', county: '',
      postcode: '', phone_number: '',
      company: '', account_id: '',
      referral_code: '', accountant_id: '' }
  end

  let(:valid_request_token) { '6f744cc412a8ffd1e3d54c6ada631253e74f352d' }
  let(:dummy_request_token) { 'foobar' }

  let(:client_settings) do
    { oauth_token: '2133085712',
      oauth_secret: '09e4a4fd5e7a5c172ef2e183046dc89bcf4d18f9',
      base_uri: 'https://app.rb-logistics.com' }
  end

  let(:client) { ReceiptBank::Client.new(client_settings) }
end
