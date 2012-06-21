require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UndoItemsController do
  describe 'handling GET to index' do
    before(:each) do
      @undo_items = [mock_model(UndoItem)]
      UndoItem.stub!(:find).and_return(@undo_items)
      session[:logged_in] = true
      get :index
    end

    it("is successful")                 { response.should be_success }
    it("renders index template")        { response.should render_template('index') }
    it("finds undo items for the view") { assigns[:undo_items].should == @undo_items }
  end

  describe 'handling POST to undo' do
    before do
      @item = mock_model(UndoItem, :complete_description => "hello")
      @item.stub!(:process!)
      UndoItem.stub!(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1
    end

    it("redirects back")                           { do_post; response.should redirect_to("/bogus") }
    it("stores complete_description in the flash") { do_post; flash[:notice].should == "hello" }
    it("processes the item")                       { @item.should_receive(:process!); do_post }
  end

  describe 'handling POST to undo accepting JSON' do
    before do
      @item = mock_model(UndoItem, :complete_description => "hello")
      @item.stub!(:process!).and_return(Post.new)
      UndoItem.stub!(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1, :format => 'json'
    end

    it("renders json")       { do_post; response.should contain(/hello/) }
    it("processes the item") { @item.should_receive(:process!); do_post }
  end

  describe 'handling POST to undo with invalid undo item' do
    before do
      @item = mock_model(UndoItem)
      @item.stub!(:process!).and_raise(UndoFailed)
      UndoItem.stub!(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1
    end

    it("redirects back")             { do_post; response.should redirect_to("/bogus") }
    it("stores notice in the flash") { do_post; flash[:notice].should_not be_nil }
  end

  describe 'handling POST to undo with invalid undo item accepting JSON' do
    before do
      @item = mock_model(UndoItem)
      @item.stub!(:process!).and_raise(UndoFailed)
      UndoItem.stub!(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1, :format => 'json'
    end

    it("renders json") { do_post; response.should contain(/message/) }
  end
end
