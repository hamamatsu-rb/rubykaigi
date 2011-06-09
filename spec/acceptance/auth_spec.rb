require "acceptance/acceptance_helper"

feature "ユーザとして初めてOAuthでログインする" do 
  background do
    OmniAuth.config.mock_auth[:twitter] = {
      :provider  => "twitter",
      :uid       => "12345",
      :user_info => {:nickname => "hibariya", :name => "Hibariya Hi"}
    }
    visit "/auth/twitter"
  end

  after :all do
    click_link "Sign out"
  end

  scenario "認証後にはアカウント編集画面が表示されること" do
    page.current_path.should eq new_account_path
  end

  scenario "ユーザ名、フルネームはOAuthのアカウント情報から引き継がれていること" do
    page.find("#rubyist_username").value.should  eq "hibariya"
    page.find("#rubyist_full_name").value.should eq "Hibariya Hi"
  end

  scenario "Sign upボタンを押下すると、アカウントが作成されログイン状態となっていること" do
    click_button "Sign up"
    page.find("#topBar .name").text.strip.should eq "hibariya"
  end
end

feature "ユーザとして初めてOpenIDでログインする" do
   background do
    OmniAuth.config.mock_auth[:open_id] = {
      :provider  => "open_id",
      :uid       => "https://www.google.com/accounts/o8/id?i://www.google.com/accounts/o8/id?id=hibariya",
      :user_info => {:email => "hibariya@gmail.com", :name => "Hibariya Hi"}
    }
    visit "/auth/open_id"
  end

  after :all do
    click_link "Sign out"
  end

  scenario "認証後にはアカウント編集画面が表示されること" do
    page.current_path.should eq new_account_path
  end

  scenario "フルネーム、メールアドレスはOpenIDのアカウント情報から引き継がれていること" do
    page.find("#rubyist_full_name").value.should eq "Hibariya Hi"
    page.find("#rubyist_email").value.should  eq "hibariya@gmail.com"
  end

  scenario "Sign upボタンを押下すると、アカウントが作成されログイン状態となっていること" do
    fill_in "Username", :with => "hibariya"
    click_button "Sign up"
    page.find("#topBar .name").text.strip.should eq "hibariya"
  end
end

feature "既存のユーザとしてログインする" do 
  let(:rubyist) do
    Rubyist.create!(:full_name=>"Hibariya Hi", :username=>"hibariya", :provider=>"twitter") do |r|
      r.uid = "12345"
    end
  end

  background do
    OmniAuth.config.mock_auth[:twitter] = {
      :provider  => "twitter",
      :uid       => rubyist.uid,
      :user_info => {:nickname => rubyist.username, :name => rubyist.full_name}
    }
    visit "/auth/twitter"
  end

  after :all do
    click_link "Sign out"
  end

  scenario "認証後にはダッシュボードが表示されていること" do
    page.current_path.should eq dashboard_path
  end
end
