require 'spec_helper'

describe AccountsController do
  describe 'GET /account/new' do
    context 'with Twitter credentials' do
      before do
        session[:params_from_authenticator] = {:uid => '4567', :provider => 'twitter',
                                               :user_info => {:nickname => 'hibariya', :name => 'Hibariya Hi'}}
        get :new
      end

      it { response.should be_success }
    end

    context 'with OpenID credentials' do
      before do
        session[:params_from_authenticator] = {:uid => 'http://ursm.jp/', :provider => 'open_id',
                                               :user_info => {:name => 'hibariya'}}
        get :new
      end

      it { response.should be_success }
    end

    context 'no credentials' do
      before do
        get :new
      end

      it { response.should redirect_to(signin_path) }
    end
  end

  describe 'POST /account' do
    def post_create_account_with_mock
      post :create, :rubyist => Rubyist.plan
    end

    shared_examples_for 'Signed up successfully' do
      it { session[:params_from_authenticator].should be_nil }
    end

    shared_examples_for 'Signed up successfully without return_to' do
      it_should_behave_like 'Signed up successfully'
      it { response.should redirect_to(root_path) }
    end

    shared_examples_for 'Signed up successfully with return_to' do
      it_should_behave_like 'Signed up successfully'
      it { response.should redirect_to('http://example.com/return_to') }
      it { session[:return_to].should be_nil }
    end

    shared_examples_for 'Signed up failed' do
      it { response.should be_success }
      it { response.should render_template(:new) }
    end

    context 'with Twitter credentials' do
      before do
        session[:params_from_authenticator] = {:uid => '4567', :provider => 'twitter',
                                               :user_info => {:nickname => 'hibariya', :name => 'Hibariya Hi'}}
      end

      context 'saved' do
        before do
          post_create_account_with_mock
        end

        it_should_behave_like 'Signed up successfully without return_to'
        it { assigns[:rubyist].authentications.last.uid.should == '4567' }
      end

      context 'saved with return_to' do
        before do
          session[:return_to] = 'http://example.com/return_to'
          post_create_account_with_mock
        end

        it_should_behave_like 'Signed up successfully with return_to'
        it { assigns[:rubyist].authentications.last.uid.should == '4567' }
      end

      context 'failed' do
        before do
          dont_allow(controller).user = anything
          post :create, :rubyist => Rubyist.plan(:invalid)
        end

        it_should_behave_like 'Signed up failed'
        it { session[:params_from_authenticator][:uid].should == '4567' }
      end
    end

    context 'with OpenID credentials' do
      before do
        session[:params_from_authenticator] = {:uid => 'http://ursm.jp/', :provider => 'open_id',
                                               :user_info => {:name => 'hibariya'}}
      end

      context 'saved' do
        before do
          post_create_account_with_mock
        end

        it_should_behave_like 'Signed up successfully without return_to'
        it { assigns[:rubyist].authentications.last.uid.should == 'http://ursm.jp/' }
      end

      context 'saved with return URL' do
        before do
          session[:return_to] = 'http://example.com/return_to'
          post_create_account_with_mock
        end

        it_should_behave_like 'Signed up successfully with return_to'
        it { assigns[:rubyist].authentications.last.uid.should == 'http://ursm.jp/' }
      end

      context 'failed' do
        before do
          dont_allow(controller).user = anything
          post :create, :rubyist => Rubyist.plan(:invalid)
        end

        it_should_behave_like 'Signed up failed'
        it { session[:params_from_authenticator][:uid].should == 'http://ursm.jp/' }
      end
    end

    context 'no credentials' do
      before do
        post :create, :rubyist => {:username => 'ursm'}
      end

      it { response.should redirect_to(signin_path) }
    end
  end

  describe 'GET /account/edit' do
    context 'signed in' do
      before do
        @ursm = Rubyist.make(:authentications => [Authentication.new(:provider => 'twitter', :uid => '12345')])
        sign_in_as @ursm
        get :edit
      end

      it { response.should be_success }
      it { assigns[:rubyist].should == @ursm }
    end

    context 'not signed in' do
      before do
        not_signed_in
        get :edit
      end

      it { response.should redirect_to(signin_path) }
    end
  end

  describe 'POST /account' do
    context 'signed in' do
      before do
        @ursm = Rubyist.make(:authentications => [Authentication.new(:provider => 'twitter', :uid => '12345')])
        sign_in_as @ursm
      end

      context 'with valid params' do
        before do
          post :update, :rubyist => Rubyist.plan
        end

        it { response.should redirect_to(edit_account_path) }
      end

      context 'with invalid params' do
        before do
          post :update, :rubyist => Rubyist.plan(:invalid)
        end

        it { response.should be_success }
        it { response.should render_template(:edit) }
        it { assigns[:rubyist].should == @ursm }
      end
    end

    context 'not signed in' do
      before do
        not_signed_in
        get :edit
      end

      it { response.should redirect_to(signin_path) }
    end
  end
end
