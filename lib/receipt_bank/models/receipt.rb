module ReceiptBank
  module Models
    class Receipt < ReceiptBank::Models::BaseModel
      attr_accessor :local_image_file_path

      def self.inbox(user)
        options = { sessionid: user.session[:session_id] }
        process_results user.client_connection,
                        user.client_connection.query_post_api("#{BASE_URI}inbox", options),
                        'receipts'
      end

      def self.upload_receipt(user, image_file_path)
        options = { sessionid: user.session[:session_id] }
        user.client_connection.query_post_file(build_url(:upload_new_receipt_image),
                                               options,
                                               :photo, image_file_path)
      end

      def self.build_url(resource_action)
        return "#{BASE_URI}postReceipt" if resource_action == :upload_new_receipt_image
        return "#{BASE_URI}update_receipt_data" if resource_action == :update_receipt_data
        super
      end

      def get_image
        options = { sessionid: session[:session_id], id: id }
        client_connection.query_post_api("#{BASE_URI}image", options)
      end

      def publish
        options = { sessionid: session[:session_id], id: id }
        client_connection.query_post_api("#{BASE_URI}publish_receipt", options)
      end

      def save
        return save_new_image if !has_attribute?('id') && local_image_file_path && !local_image_file_path.empty?
        options = { data: build_changed_data.to_json, id: id }.merge(build_session_data)
        response = client_connection.query_post_api(self.class.build_url(:update_receipt_data), options)
        set_all_attributes(response[self.class.resource_name].first, true) if response['size'] > 0
        self
      end

      def save_new_image
        response = self.class.upload_receipt(client_connection.current_user,
                                             local_image_file_path)

        set_attribute('id', response['receiptid'], true)
        self
      end
    end
  end
end
