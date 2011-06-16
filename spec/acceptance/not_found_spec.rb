require 'acceptance/acceptance_helper'

feature 'page does not found' do
  scenario "/2010/ja/registration" do
    pending "今は200が返ってくるので要確認"
    header 'Accept-Language', 'ja'
    visit '/2010/ja/registration'
    page.status_code.should == 404
  end
end
