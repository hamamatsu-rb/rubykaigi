require 'spec_helper'

describe Admin::RubyistsController do
  context 'ログインしていない' do
    before do
      not_signed_in
      get :index
    end

    pending { response.should redirect_to(new_sessions_path) }
  end

  context '一般参加者としてログインしている' do
    before do
      sign_in_as Rubyist.make
      get :index
    end

    pending { response.response_code.should == 403 }
  end

  context 'スタッフとしてログインしている' do
    before do
      sign_in_as make_rubyist_as_staff
      get :index
    end

    pending { response.should be_success }
  end
end
