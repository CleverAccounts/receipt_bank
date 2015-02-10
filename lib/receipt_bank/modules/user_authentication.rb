module ReceiptBank
  module UserAuthentication
    def current_user
      @current_user && @current_user.session ? @current_user : nil
    end

    def login(email, password)
      response = query_post_api("#{ReceiptBank::Models::BaseModel::BASE_URI}login",
                                login: email, password: password)

      session = build_session_data_from_response(response).merge(email: email,
                                                                 password: password)

      query_options = { email: email, sessionid: session[:session_id] }
      @current_user = ReceiptBank::Models::User.find_raw(self, query_options).first
      @current_user.session = session
      @current_user
    end

    def build_session_data_from_response(response)
      { session_id: response['sessionid'],
        permissions: { delete: response['permissions']['delete'] == 1,
                       publish: response['permissions']['publish'] == 1,
                       erchive: response['permissions']['archive'] == 1 } }
    end
  end
end
