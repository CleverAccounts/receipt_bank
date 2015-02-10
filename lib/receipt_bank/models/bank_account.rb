module ReceiptBank
  module Models
    class BankAccount < ReceiptBank::Models::BaseModel
      def self.resource_name
        'bank_accounts'
      end

      def save; end

      def delete; end
    end
  end
end
