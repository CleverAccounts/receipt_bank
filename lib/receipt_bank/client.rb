module ReceiptBank
  class Client
    include ReceiptBank::SingleSignOn
    include ReceiptBank::UserAuthentication
    include ReceiptBank::AccountManagement

    attr_accessor :base_uri, :oauth_token, :oauth_secret

    def initialize(options = {base_uri:nil, oauth_token:nil, oauth_secret:nil})
      raise ArgumentError.new("You must specifiy valid options") unless options.keys.count > 0
      options.each { |k,v|
        raise ArgumentError.new("#{k} can not be nil or empty") if v.nil? || v.empty?
        self.send("#{k}=", v)
      }
    end

    def make_request_url(url, options)
      "#{url}?#{build_params(options)}"
    end

    def query_get_api(url, options)
      JSON.parse(session.get(make_request_url(url, options)).body)
    end

    def query_post_api(url, options)
      response = session.post { |req|
          req.url url
          req.headers['Content-Type'] = 'application/json'
          req.body = options.to_json
      }
      JSON.parse(response.body)
    end

    def query_post_file(url, options, field_name, file_path)
      options[field_name] = Faraday::UploadIO.new(file_path, 'image/jpeg')
      response = session.post url, options
      JSON.parse(response.body)
    end

private

    def build_params(options)
      options.merge!(client_id: oauth_token.to_s, client_secret: oauth_secret)
      to_query(options)
    end

    def to_query(options)
      Faraday::Utils.build_nested_query(options)
    end

    def session
      @connection ||= ::Faraday.new(base_uri) do |conn|
        conn.request :multipart
        conn.adapter Faraday.default_adapter
        conn.use Faraday::Response::ReceiptBank
      end
    end

  end
end
