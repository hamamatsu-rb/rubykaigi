class SessionsController < ApplicationController
  layout_for_latest_ruby_kaigi

  def new
  end

  def create
    auth = request.env["omniauth.auth"]
    if user = Rubyist.where(:provider => auth[:provider], :uid => auth[:uid]).first
      session[:user_id] = user.id
      redirect_to session.delete(:return_to) || dashboard_path
    else
      store_auth_params(auth)
      redirect_to new_account_path
    end
  end

  def destroy
    session.delete :user_id
    redirect_to signin_path, :notice => 'You have signed out successfully'
  end

  def failure
    flash[:error] = "Authentication error: #{params[:message].humanize}"
    redirect_to signin_path
  end

  private

  def store_auth_params(auth)
    store_twitter_profile(auth) if auth[:provider] == 'twitter'
    paramz = auth.slice(:provider, :uid)
    paramz[:email]     = auth[:user_info][:email]
    paramz[:username]  = auth[:user_info][:nickname]
    paramz[:full_name] = auth[:user_info][:name]
    session[:params_from_authenticator] = paramz
  end

  def store_twitter_profile(auth)
    begin
      profile = {:screen_name       => auth[:user_info][:nickname],
                 :profile_image_url => auth[:user_info][:image]}
      TwitterProfile[auth[:uid]] = profile
    rescue Errno::ECONNREFUSED => e
      Rails.logger.warn e
    end
  end
end
