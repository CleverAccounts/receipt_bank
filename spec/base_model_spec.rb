require 'spec_helper'
class MockModel < ReceiptBank::Models::BaseModel; end
describe 'base_model' do
  include_context 'configuration'
  let(:attributes) { { id: 1, name: 'dummy name' } }
  let(:mock_model) { MockModel.new(client, attributes, true) }
  describe 'Attributes' do
    it 'has a client instance' do
      expect(mock_model.client_connection.class).to eq ReceiptBank::Client
    end

    it 'has access to attribute' do
      expect(mock_model.id).to eq attributes[:id]
    end

    it 'has can set an existing attribute' do
      mock_model.name = 'foobar'
      expect(mock_model.name).to eq 'foobar'
    end

    it 'has no changed attribtues ' do
      expect(mock_model.dirty?).to eq false
    end

    it 'has changed attribtues ' do
      mock_model.name = 'foobar'
      expect(mock_model.dirty?).to eq true
    end

    it 'finds changed attribtues' do
      mock_model.name = 'foobar'
      expect(mock_model.get_dirty_attributes.keys.include?('name')).to eq true
      expect(mock_model.get_dirty_attributes.keys.include?('id')).to eq false
    end
  end
end
