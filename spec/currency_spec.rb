require 'spec_helper'
describe 'Currency' do
  include_context 'configuration'

  it 'returns the list of avaliable currencies' do
    VCR.use_cassette('currency_list') do
      client.login(user_details[:email], user_details[:password])
      expect(ReceiptBank::Models::Currency.find(client.current_user).class).to be Array
    end
  end
  it 'can not be created directly' do
    expect do
      ReceiptBank::Models::Currency.new(client, name: 'foobar')
    end.to raise_error(ReceiptBank::NotSupported)
  end
end
