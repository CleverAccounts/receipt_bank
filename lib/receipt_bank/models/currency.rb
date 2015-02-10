module ReceiptBank
  module Models
    class Currency < ReceiptBank::Models::BaseModel

      def self.resource_name
        "available_currencies"
      end

      def self.process_results(client, results)
        results["currencies"].inject([]) { |arr, currency_name|
          arr << self.new(client, {name:currency_name}, true)
        }
      end

      def save;end
      def detele;end

      private

      def initialize(client, optinos, loaded_from_server = false)
        raise ReceiptBank::NotSupported.new("") unless loaded_from_server
        super
      end

    end
  end
end
