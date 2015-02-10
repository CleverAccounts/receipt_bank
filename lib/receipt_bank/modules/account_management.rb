module ReceiptBank

  module AccountManagement

    def account_management
      @account_management ||= AccountManagementClient.new(self)
    end

    class AccountManagementClient

      attr_accessor :client_connection

      DEFAULT_USER_OPTIONS = { first_name: '', last_name: '',
                                email: "", password: '',
                                currency: '', country: '',
                                address_line_1: '', address_line_2: '',
                                town: '', county: '',
                                postcode: '', phone_number: '',
                                company: '', account_id: '',
                                referral_code: '', accountant_id: '' }

      def initialize(client)
        @client_connection = client
      end

      def session
        client_connection.current_user.session
      end

      def list_users

        raise ReceiptBank::NotSupported.new("You must be logged on") unless session && session.has_key?(:session_id)

        response = client_connection.query_post_api("api/list_users", {:sessionid => session[:session_id]})
        response["users"].inject([]) { |arr, u|
          arr << Models::User.new(nil, u, true)
        }
      end

      def create_user(user_options, user_password = SecureRandom.hex(10))

        user_options = DEFAULT_USER_OPTIONS.merge({password:user_password}.merge(user_options))
        payload = { authorization: oauth_credentials, user: user_options }
        response = client_connection.query_post_api(::ReceiptBank::URI_API_USER, payload)
        response.merge(user_options)

      end

      def delete_user()

      end

      def oauth_credentials
        { client_id: client_connection.oauth_token.to_s,
          client_secret: client_connection.oauth_secret}
      end
    end
  end
end
