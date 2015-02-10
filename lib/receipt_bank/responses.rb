module Faraday
  class Response::ReceiptBank < Response::Middleware
    def call(env)
      @app.call(env).on_complete do
        response = JSON.parse(env[:body])
        check_status response, env
      end
    end

    def check_status(json_body, env)
      return if json_body.is_a? Array

      if (error_code = (json_body['errors'] || json_body['errorcode']))

        return if is_invalid_session_on_logout?(env[:url].path, error_code)

        error_message = json_body['errormessage'] || json_body['errors'].join("\n") rescue ''

        fail get_error_class(error_code).new(error_code, error_message)

      end
    end

    def is_invalid_session_on_logout?(uri_path, error_code)
      uri_path == '/api/logout' && error_code == 403
    end

    def get_error_class(error_code)
      case error_code
      when 400 then ReceiptBank::DuplicateReceipt
      else ReceiptBank::ApiException
      end
    end
  end
end
