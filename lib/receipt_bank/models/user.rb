module ReceiptBank
  module Models
    class User < ReceiptBank::Models::BaseModel
      attr_accessor :session

      def self.find_raw(client_connection, options)
        response = client_connection.query_post_api('api/list_users', options)
        response['users'].inject([]) do |arr, u|
          arr << Models::User.new(client_connection, u, true)
        end
      end

      def logout
        client_connection.query_post_api('/api/logout',
                                         session_id: session[:session_id]) if @session
        @session = nil
        true
      end

      def receipts
        ReceiptBank::Models::Receipt.find(self)
      end

      def create_receipt(options = {})
        ReceiptBank::Models::Receipt.new(client_connection, options, false)
      end
    end
  end
end
