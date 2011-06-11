# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
#  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'fee0b697461c79843a3833b6d7754c04'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  class << self
    private

    def layout_for_latest_ruby_kaigi
      layout proc{|c| "ruby_kaigi#{RubyKaigi.latest_year}" }
    end
  end

  private

  def user
    @user ||= Rubyist.find_by_id session[:user_id]
  end

  def authenticated?
    user.present?
  end

  helper_method :authenticated?, :user

  def login_required
    return true if user

    session[:return_to] = request.fullpath
    redirect_to signin_path
    false
  end

  def staff_only
    return false unless login_required
    return true if user.staff?

    render :file => Rails.root + 'public/403.html', :status => :forbidden
    false
  end

  def basic_auth_required_by_admin
    authenticate_or_request_with_http_basic("restricted ared: username is rubykaigi, password is itsumono.") do |username, password|
      username == configatron.basic_auth.admin.username &&
        password == configatron.basic_auth.admin.password
    end
  end

  def basic_auth_required_by_sponsor
    authenticate_or_request_with_http_basic("restricted ared: sonsors only.") do |username, password|
      username == configatron.basic_auth.sponsor.username &&
        password == configatron.basic_auth.sponsor.password
    end
  end

  def current_cart
    cart = session[:cart]
    session[:cart] = __renew_cart_if_old_version_is_stored(cart)
  end

  def __renew_cart_if_old_version_is_stored(cart)
    return Cart.new unless cart
    return Cart.new unless cart.class.respond_to?(:model_name)
    cart
  end

  def render_not_found
    render(:status => 404, :file => 'public/404.html')
  end

  def render_forbidden
    render(:status => 403, :file => 'public/403.html')
  end

  def render_unprocessable
    render(:status => 422, :file => 'public/422.html')
  end

  # XXX duplicated in application_helper.rb
  def current_locale
    I18n.locale
  end
end
