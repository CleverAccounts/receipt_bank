module ReceiptBank
  module SingleSignOn

    def sso
      @sso = SingleSignOnClient.new(self)
    end

    class SingleSignOnClient

      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get_user_login_url(user_refresh_token)
        response = client.query_get_api(::ReceiptBank::URI_OAUTH_TOKEN,
                                        {refresh_token:user_refresh_token})

        client.make_request_url("#{client.base_uri}#{::ReceiptBank::URI_SSO}",
                                {login_token:response["login_token"]})
      end
    end
  end
end
