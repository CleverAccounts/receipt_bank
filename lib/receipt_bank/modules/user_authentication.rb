module ReceiptBank

  module UserAuthentication

    def current_user
      @current_user && @current_user.session ? @current_user : nil
    end

    def login(email, password)
      response = self.query_post_api("#{ReceiptBank::Models::BaseModel::BASE_URI}login",
                                     { login:email, password:password})

      session = { email:email, password:password,
                  session_id: response["sessionid"],
                  permissions: { delete: response["permissions"]["delete"] == 1,
                                publish: response["permissions"]["publish"] == 1,
                                erchive: response["permissions"]["archive"] == 1 } }



      query_options = { email:email, sessionid:session[:session_id] }
      user = ReceiptBank::Models::User.find_raw(self, query_options).first
      user.session = session
      @current_user = user
    end
  end

end
