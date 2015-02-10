module ReceiptBank

  module Models

    class User < ReceiptBank::Models::BaseModel

      attr_accessor :session

      def self.find_raw(client_connection, options)
        response = client_connection.query_post_api("api/list_users", options)
        response["users"].inject([]) { |arr, u|
          arr << Models::User.new(client_connection, u, true)
        }
      end

      def logout
        client_connection.query_post_api("/api/logout",
                                         {session_id:session[:session_id] }) if @session
        @session = nil
        true
      end

      def receipts
        ReceiptBank::Models::Receipt.find(self)
      end

      def create_receipt(file_name, options = {})
        ReceiptBank::Models::Receipt.new(self.client_connection,
                                         { local_image_file_path:file_name }.merge(options))
      end

    end

  end
end
