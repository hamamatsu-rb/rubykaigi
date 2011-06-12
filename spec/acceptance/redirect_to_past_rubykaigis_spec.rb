require 'acceptance/acceptance_helper'

feature 'RubyKaigi2008以前の公式サイトへのリダイレクト', %q{
  RubyKaigi2008以前のURLは覚えづらいようなので、
  rubykaigi.orgを手掛りにそれっぽいURLは過去開催の公式サイトにリダイレクトするようにしたい
  SEO的な観点から、サブドメイン(2008.rubykaigi.org)ではなくサブディレクトリ(rubykaigi.org/2008)で
  アクセスできるようにする。
  2009以降は、リダイレクトせずに静的ファイル化やキャッシュで対応する
} do

  %w(2006 2007 2008).each do |year|
    scenario "/#{year} にアクセスする" do
      visit "/#{year}"
      page.driver.current_url.should == "http://jp.rubyist.net/RubyKaigi#{year}"
    end
  end
end
