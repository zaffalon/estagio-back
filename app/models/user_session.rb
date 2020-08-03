class UserSession < Authlogic::Session::Base
  attr_accessor :token
  # find_by_login_method :find_by_openid_identifier

  after_save {
    if self.user.start_test_until.nil?
      self.user.start_test_until = Time.current + 5.days
      StartTestWorker.perform_in(self.user.start_test_until, self.user.id)
    end
  }
  # allow_http_basic_auth false
  # password_field :openid_identifier
end