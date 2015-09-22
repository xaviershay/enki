require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::UndoItemsController do
  describe 'handling GET to index' do
    before(:each) do
      @undo_items = [mock_model(UndoItem)]
      allow(UndoItem).to receive_message_chain(:order, :limit, :all).and_return(@undo_items)
      session[:logged_in] = true
      get :index
    end

    it("is successful")                 { expect(response).to be_success }
    it("renders index template")        { expect(response).to render_template('index') }
    it("finds undo items for the view") { expect(assigns[:undo_items]).to eq(@undo_items) }
  end

  describe 'handling POST to undo' do
    before do
      @item = mock_model(UndoItem, :complete_description => "hello")
      allow(@item).to receive(:process!)
      allow(UndoItem).to receive(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1
    end

    it("redirects back")                           { do_post; expect(response).to redirect_to("/bogus") }
    it("stores complete_description in the flash") { do_post; expect(flash[:notice]).to eq("hello") }
    it("processes the item")                       { expect(@item).to receive(:process!); do_post }
  end

  describe 'handling POST to undo accepting JSON' do
    before do
      @item = mock_model(UndoItem, :complete_description => "hello")
      allow(@item).to receive(:process!).and_return(Post.new)
      allow(UndoItem).to receive(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1, :format => 'json'
    end

    it("renders json")       { do_post; expect(response.body).to match(/hello/) }
    it("processes the item") { expect(@item).to receive(:process!); do_post }
  end

  describe 'handling POST to undo with invalid undo item' do
    before do
      @item = mock_model(UndoItem)
      allow(@item).to receive(:process!).and_raise(UndoFailed)
      allow(UndoItem).to receive(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1
    end

    it("redirects back")             { do_post; expect(response).to redirect_to("/bogus") }
    it("stores notice in the flash") { do_post; expect(flash[:notice]).not_to be_nil }
  end

  describe 'handling POST to undo with invalid undo item accepting JSON' do
    before do
      @item = mock_model(UndoItem)
      allow(@item).to receive(:process!).and_raise(UndoFailed)
      allow(UndoItem).to receive(:find).and_return(@item)
    end

    def do_post
      request.env["HTTP_REFERER"] = "/bogus"
      session[:logged_in] = true
      post :undo, :id => 1, :format => 'json'
    end

    it("renders json") { do_post; expect(response.body).to match(/message/) }
  end
end
