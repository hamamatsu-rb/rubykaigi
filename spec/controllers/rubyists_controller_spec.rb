require 'spec_helper'

describe RubyistsController do
  describe 'GET /show' do
    before do
      @ursm = Rubyist.make(:username => 'ursm')
      get :show, :id => 'ursm', :locale => 'ja'
    end

    it { response.should be_success }
    it { assigns[:rubyist].should == @ursm }
  end
end
