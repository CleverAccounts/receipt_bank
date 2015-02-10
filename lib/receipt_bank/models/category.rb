module ReceiptBank
  module Models
    class Category < ReceiptBank::Models::BaseModel
      def self.resource_name
        'categories'
      end
    end
  end
end
