require 'spec_helper'
  describe "Bank" do

    include_context "configuration"

    it "returns the list of avaliable bank accounts" do
      VCR.use_cassette("bank_account_list_success") do
        client.login(user_details[:email], user_details[:password])
        expect(ReceiptBank::Models::BankAccount.find(client.current_user).is_a?(Array)).to be true
      end
    end
  end

