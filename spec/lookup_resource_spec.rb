require 'spec_helper'
def classes_to_test
  [{ klass:ReceiptBank::Models::Client,
    additional_attributes: {} },
  { klass:ReceiptBank::Models::Payee,
    additional_attributes: {} },
  { klass:ReceiptBank::Models::Project,
    additional_attributes: {} },
  { klass:ReceiptBank::Models::Category,
    additional_attributes:{ code:"123" }} ]
end

describe "Lookups" do
  describe "Generic" do
    classes_to_test.each do |class_settings|

      class_type = class_settings[:klass]
      additional_attributes = class_settings[:additional_attributes]
      model_attributes = {id:"#{class_type.name.split("::").last}_1",
                          name:"#{class_type.name.split("::").last}_name"}.merge(additional_attributes)

      test_mock_file = "#{class_type.name.split("::").last.downcase}"

      describe "#{class_type.name} API" do

        include_context "configuration"

        before(:each) do
          client.login(user_details[:email], user_details[:password])
        end

        it "finds all #{class_type.name}s for the current user" do
          VCR.use_cassette("#{test_mock_file}_list_success") do
            models = class_type.find(client.current_user)
            expect(models.is_a?(Array)).to be true
          end
        end

        it "Adds a new #{class_type.name} for the current user" do
          VCR.use_cassette("#{test_mock_file}_add_success") do
            model_instance =  class_type.new(client,model_attributes)
            model_instance.save
            model_instances = class_type.find(client.current_user, {id:model_instance.id})
            expect(model_instances.count).to eq 1
            expect(model_instances.first.name).to eq "#{class_type.name.split("::").last}_name"
          end
        end

        it "updates a #{class_type.name} for the current user" do
          VCR.use_cassette("#{test_mock_file}_update_success") do
            cmp_name = "updated #{class_type.name} name"
            model_instance =  class_type.new(client,model_attributes)
            model_instance.save
            model_instance.name = cmp_name
            model_instance.save
            model_instances = class_type.find(client.current_user, {id:model_instance.id})
            expect(model_instances.count).to eq 1
            expect(model_instances.first.name).to eq cmp_name
          end
        end

        it "Deletes a #{class_type.name} for the current user" do
          VCR.use_cassette("#{test_mock_file}_delete_success") do
            model_instance =  class_type.new(client,model_attributes)
            expect(model_instance.save.id).to eq model_instance.id
            expect(model_instance.delete).to be true
            model_instances = class_type.find(client.current_user, {id:model_instance.id})
            expect(model_instances.count).to eq 0
          end
        end
      end
    end
  end
end
