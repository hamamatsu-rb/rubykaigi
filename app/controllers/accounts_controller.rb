class AccountsController < ApplicationController
  verify :session => :params_from_authenticator, :only => %w(new create), :redirect_to => :signin_path

  layout_for_latest_ruby_kaigi

  def new
    @rubyist = Rubyist.new(session[:params_from_authenticator]) do |r|
      r.uid = session[:params_from_authenticator][:uid]
    end
  end

  def create
    @rubyist = Rubyist.new(session[:params_from_authenticator]) do |r|
      r.attributes = params[:rubyist]
      r.uid = session[:params_from_authenticator][:uid]
    end

    if @rubyist.save
      session[:user_id] = @rubyist.id
      session.delete(:params_from_authenticator)

      redirect_to session.delete(:return_to) || root_path
    else
      render :new
    end
  end

  before_filter :login_required, :only => %w(edit update)

  def edit
    @rubyist = user
  end

  def update
    if user.update_attributes(params[:rubyist])
      flash[:notice] = 'Your settings have been saved.'
      redirect_to edit_account_path
    else
      @rubyist = user
      render :edit
    end
  end
end
