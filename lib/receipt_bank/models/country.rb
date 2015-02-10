module ReceiptBank
  module Models
    class Country < ReceiptBank::Models::BaseModel

      def self.resource_name
        "available_countries"
      end

      def self.process_results(client, results)
        results["countries"].inject([]) { |arr, country_name|
          arr << self.new(client, {name:country_name}, true)
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
