# -*- coding: utf-8 -*-
require 'spec_helper'

describe PagesController do
  context "page does not found" do
    render_views

    it 'should not raise missing template exception' do
      %w{2009 2010}.each do |year|
        %w{ja en}.each do |locale|
          lambda {
            get :show, {:year => year, :page_name => 'page_does_not_exist', :locale => locale}
          }.should_not raise_exception(ActionView::MissingTemplate)
        end
      end
    end

    it 'should return HTTP 404' do
      %w{2009 2010}.each do |year|
        %w{ja en}.each do |locale|
          get :show, {:year => year, :page_name => 'page_does_not_exists', :locale => locale}
          response.status.should == 404
        end
      end
    end
  end

  context 'static page exists' do
    it 'should render static file' do
      %w{2009 2010}.each do |year|
        get :show, {:year => year, :page_name => 'index', :locale => 'ja'}
        response.status.should == '200 OK'
        response.should render_template("public/#{year}/ja/index.html")
      end
    end
  end
end
