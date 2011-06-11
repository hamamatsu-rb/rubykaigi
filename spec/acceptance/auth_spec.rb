require 'acceptance/acceptance_helper'

shared_context 'signout after all' do
  after :all do
    click_link 'Sign out' rescue nil # XXX scenarioが上から順番に実行されるわけではないらしいので必要。rescue nilどうにかしたい
  end
end

feature 'ユーザとして初めてOAuthでログインする' do 
  include_context 'signout after all'

  background do
    OmniAuth.config.mock_auth[:twitter] = {
      :provider  => 'twitter',
      :uid       => '12345',
      :user_info => {:nickname => 'hibariya', :name => 'Hibariya Hi'}
    }
    visit '/auth/twitter'
  end

  scenario '認証後にはアカウント編集画面が表示されること' do
    page.current_path.should eq new_account_path
  end

  scenario 'ユーザ名、フルネームはOAuthのアカウント情報から引き継がれていること' do
    page.find('#rubyist_username').value.should  eq 'hibariya'
    page.find('#rubyist_full_name').value.should eq 'Hibariya Hi'
  end

  scenario 'Sign upボタンを押下すると、アカウントが作成されログイン状態となっていること' do
    click_button 'Sign up'
    page.find('#topBar .name').text.strip.should eq 'hibariya'
  end
end

feature 'ユーザとして初めてOpenIDでログインする' do
  include_context 'signout after all'

  background do
    OmniAuth.config.mock_auth[:open_id] = {
      :provider  => 'open_id',
      :uid       => 'https://www.google.com/accounts/o8/id?i://www.google.com/accounts/o8/id?id=hibariya',
      :user_info => {:email => 'hibariya@gmail.com', :name => 'Hibariya Hi'}
    }
    visit '/auth/open_id'
  end

  scenario '認証後にはアカウント編集画面が表示されること' do
    page.current_path.should eq new_account_path
  end

  scenario 'フルネーム、メールアドレスはOpenIDのアカウント情報から引き継がれていること' do
    page.find('#rubyist_full_name').value.should eq 'Hibariya Hi'
    page.find('#rubyist_email').value.should  eq 'hibariya@gmail.com'
  end

  scenario 'Sign upボタンを押下すると、アカウントが作成されログイン状態となっていること' do
    fill_in 'Username', :with => 'hibariya'
    click_button 'Sign up'
    page.find('#topBar .name').text.strip.should eq 'hibariya'
  end
end

feature '既存のユーザとしてログインする' do 
  include_context 'signout after all'

  let!(:rubyist) do
    Rubyist.create!(:full_name => 'Hibariya Hi', :username => 'hibariya') do |r|
      r.authentications = [Authentication.new(:provider => 'twitter', :uid => 12345)]
    end
  end

  let(:authentication) { rubyist.authentications.last }

  background do
    OmniAuth.config.mock_auth[:twitter] = {
      :provider  => 'twitter',
      :uid       => authentication.uid,
      :user_info => {:nickname => rubyist.username, :name => rubyist.full_name}
    }
    visit '/auth/twitter'
  end

  scenario '認証後にはダッシュボードが表示されていること' do
    page.current_path.should eq dashboard_path
  end
end

shared_context "password authentication" do
  let(:authentication) { rubyist.authentications.last }

  let!(:rubyist) do
    Rubyist.create!(:full_name => 'Hibariya Hi', :username => 'hibariya') do |r|
      r.authentications = [Authentication.new(:provider => 'password', :uid => 'encrypted_password')]
    end
  end
end

feature '既存のユーザとしてパスワード認証でログインする' do
  include_context 'password authentication'
  include_context 'signout after all'

  background do
    OmniAuth.config.mock_auth[:password] = {
      :provider  => 'password',
      :uid       => authentication.uid,
      :user_info => {:username => rubyist.username}
    }
    visit '/auth/password'
  end

  scenario '認証後にはダッシュボードが表示されていること' do
    page.current_path.should eq dashboard_path
  end
end

feature 'パスワード認証に失敗した場合' do
  include_context "password authentication"
  include_context 'signout after all'

  background do
    OmniAuth.config.mock_auth[:password] = {
      :provider  => 'password',
      :uid       => 'invalid_password',
      :user_info => {:username => rubyist.username}
    }
    visit '/auth/password'
  end

  scenario 'サインイン画面に遷移すること' do
    page.current_path.should eq signin_path
  end

  scenario 'エラーメッセージが表示されていること' do
    find('#flash .error').should have_content('Authentication error: Invalid username or password')
  end
end
