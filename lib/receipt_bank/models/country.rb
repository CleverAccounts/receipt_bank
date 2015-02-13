module ReceiptBank
  module Models
    class Country < ReceiptBank::Models::ReadOnlyModel
      def self.resource_name
        'available_countries'
      end
    end
  end
end
