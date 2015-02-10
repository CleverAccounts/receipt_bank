require 'spec_helper'

describe "client" do
  include_context "configuration"

  describe "client setup" do
    it "should return the correct base URL" do
      expect(client.base_uri).to eql client_settings[:base_uri]
    end
    it "should format the api request" do
      url = client.make_request_url("", zzzz: "foobar")
      expect(url).to eql "?client_id=#{client_settings[:oauth_token]}" +
        "&client_secret=#{client_settings[:oauth_secret]}" +
        "&zzzz=foobar"
    end
  end
end

