require 'spec_helper'

describe 'Receipt API' do
  include_context 'configuration'

  before(:each) do
    client.login(user_details[:email], user_details[:password])
  end

  it 'lists all inbox items' do
    VCR.use_cassette('receipt_inbox_list_all_success') do
      receipts = ReceiptBank::Models::Receipt.inbox(client.current_user)
      expect(receipts.count)
    end
  end

  it 'reloads receipts data fromt the server items' do
    VCR.use_cassette('receipt_reload_success') do
      receipts = ReceiptBank::Models::Receipt.inbox(client.current_user)
      receipt = receipts.first
      receipt.reload
    end
  end

  it 'retreives the image of the first receipt' do
    VCR.use_cassette('receipt_retreives_image_success') do
      receipts = ReceiptBank::Models::Receipt.inbox(client.current_user)
      image_result = receipts.first.get_image
      test_receipt_size = File.size(File.expand_path('spec/receipts/receipt_1.jpg'))
      expect(image_result['file_size']).to eq test_receipt_size
    end
  end

  it 'lists all the users receipts' do
    VCR.use_cassette('receipt_list_all_success') do
      receipts = ReceiptBank::Models::Receipt.find(client.current_user)
      expect(receipts.class).to eq Array
    end
  end

  it 'publishes a users receipts' do
    VCR.use_cassette('receipt_publish_success') do
      receipts = ReceiptBank::Models::Receipt.find(client.current_user)
      receipts.first.publish
    end
  end

  it 'can not post a duplicate receipt to the server' do
    VCR.use_cassette('receipt_post_duplicate_success') do
      error_message = 'This item was rejected as this file already exists within this account.'
      receipt_file_path = File.expand_path('spec/receipts/receipt_1.jpg')
      expect do
        ReceiptBank::Models::Receipt.upload_receipt(client.current_user,
                                                    receipt_file_path)
      end.to raise_error(ReceiptBank::DuplicateReceipt, error_message)
    end
  end

  it 'updates the data of the receipt' do
    VCR.use_cassette('receipt_update_data_success') do
      new_description = 'test receipt description'
      receipts = ReceiptBank::Models::Receipt.inbox(client.current_user)
      receipt = receipts.first
      receipt.description = new_description
      receipt.save
      expect(receipt.description).to eq new_description
    end
  end

  it 'creates a new receipt from an image using new and save' do
    VCR.use_cassette('receipt_create_new_success') do
      receipt_file_path = File.expand_path('spec/receipts/receipt_2.jpg')
      receipt = ReceiptBank::Models::Receipt.new(client, { local_image_file_path: receipt_file_path }, false)
      expect(receipt.save.id).to be > 0
    end
  end
end
