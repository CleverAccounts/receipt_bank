require 'spec_helper'

describe "Account Management" do
  include_context "configuration"

  describe "User" do
    it "lists all users for the currently logged on user" do
      VCR.use_cassette("acc_mgnt_list_users") do
        client.login(user_details[:email], user_details[:password])
        result = client.account_management.list_users
        email_address = user_details[:email].downcase
        email_addresses = result.map(&:email).map(&:downcase)
        expect(email_addresses.include?(email_address)).to be true
      end
    end

    it "creates a new main user" do
      VCR.use_cassette("acc_mgnt_user_create") do
        result = client.account_management.create_user(user_details)
        expect(result["status"]).to eq "OK"
      end
    end

    it "does not create a new user if one exists" do
      VCR.use_cassette("acc_mgnt_user_create_dup_email") do
        expect do
          client.account_management.create_user(user_details)
        end.to raise_error(ReceiptBank::ApiException, "Email has already been taken")
      end
    end

    it "creates a new user with a system generated password" do
    end

    it "deletes a user" do
    end
  end
end
