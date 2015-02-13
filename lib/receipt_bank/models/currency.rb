module ReceiptBank
  module Models
    class Currency < ReceiptBank::Models::ReadOnlyModel
      def self.resource_name
        'available_currencies'
      end
    end
  end
end
