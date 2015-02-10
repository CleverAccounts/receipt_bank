module ReceiptBank
  class BaseError < StandardError
    attr_accessor :result_code
    def initialize(result_code, message)
      @result_code = result_code
      super(message)
    end
  end
  class AuthenticationError < BaseError ;end
  class ApiException < BaseError;end
  class InvalidParameterError < BaseError;end
  class QuotaExceededError < BaseError; end
  class NotSupported < StandardError; end
  class DuplicateReceipt < BaseError; end
end
