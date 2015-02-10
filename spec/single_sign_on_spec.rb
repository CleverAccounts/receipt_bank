require 'spec_helper'

describe "SSO" do
  include_context "configuration"

  describe "Single Sign On URL generation" do
    it 'will throw an api execption as request token is invalid' do
      VCR.use_cassette("sso_invalid_request_token") do
        exception_message = "Invalid refresh token"
        expect do
          client.sso.get_user_login_url(dummy_request_token)
        end.to raise_error(ReceiptBank::ApiException,exception_message)
      end
    end
    it 'will generate a valid login url' do
      VCR.use_cassette("sso_valid_request_token") do
        uri = URI.parse( client.sso.get_user_login_url(valid_request_token))
        param_hash = Hash[URI.decode_www_form(uri.query)]
        expect( param_hash.has_key?("login_token") && (param_hash["login_token"].size > 0)).to be true
        expect( uri.path ).to eql ::ReceiptBank::URI_SSO
        expect( param_hash["client_id"]).to eql client_settings[:oauth_token]
        expect( param_hash["client_secret"]).to eql client_settings[:oauth_secret]
      end
    end
  end
end
