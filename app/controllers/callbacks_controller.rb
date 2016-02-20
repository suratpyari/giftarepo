class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    session[:login_token] = request.env["omniauth.auth"].credentials.token
    sign_in_and_redirect @user
  end
end