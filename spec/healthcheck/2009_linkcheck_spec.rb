require 'open-uri'
require 'nokogiri'
require 'uri'
require 'net/http'

module LinkCheckMacro
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def target
      @@target ||= URI.parse((t = ENV['TARGET']) ? t : 'http://localhost:3000')
    end

    def specify_all_paths_return_success(base_url, paths)
      paths.each do |path|
        specify(path) do
          Net::HTTP.start(base_url.host, base_url.port) do |http|
            http.head(path).code.should == "200"
          end
        end
      end
    end

    def it_should_be_accessible(path, title)
      base_url = target + path
      page = Nokogiri(open(base_url).read)

      it("title tag includes '#{title}'"){ page.css('title').inner_text.should match(title) }

      script_paths = page.search('script').map{|e|e.attr('src')}.compact.uniq
      specify_all_paths_return_success(base_url, script_paths)

      css_paths = page.search('link[rel="stylesheet"]').map{|e|e.attr('href')}.compact.uniq
      specify_all_paths_return_success(base_url, css_paths)

      # internal link only
      img_paths = page.search('img').map{|e|e.attr('src')}.compact.uniq.select{|u| u =~ %r!\A/!}
      specify_all_paths_return_success(base_url, img_paths)

      # internal link only
      links = page.search('a').map{|e|e.attr('href')}.compact.uniq.select{|u| u =~ %r!\A/!}
      specify_all_paths_return_success(base_url, links)
    rescue Errno::ECONNREFUSED
      pending 'server not available'
    end
  end
end

describe "リンクのチェック" do
  include LinkCheckMacro

  describe "2009/ja" do
    it_should_be_accessible "/2009/ja", "日本Ruby会議2009"
    it_should_be_accessible "/2009/ja/talks", "タイムテーブル"
    it_should_be_accessible "/2009/ja/goodies", "日本Ruby会議2009"
  end

  describe "/2009/en" do
    it_should_be_accessible "/2009/en", "RubyKaigi2009"
    it_should_be_accessible "/2009/en/talks", "Timetable"
    it_should_be_accessible "/2009/en/goodies", "RubyKaigi2009"
  end
end
