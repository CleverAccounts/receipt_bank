require 'spec_helper'
describe "Country " do
  include_context "configuration"

  it "returns the list of avaliable countries" do
    VCR.use_cassette("country_list_success") do
      client.login(user_details[:email], user_details[:password])
      expect(ReceiptBank::Models::Country.find(client.current_user).is_a?(Array)).to be true
    end
  end
  it "can not be created directly" do
    expect do
      ReceiptBank::Models::Country.new(client, name:"foobar")
    end.to raise_error(ReceiptBank::NotSupported)
  end
end

