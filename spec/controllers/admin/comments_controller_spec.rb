require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../../factories'
require 'json'

describe Admin::CommentsController do
  describe 'handling GET to index' do
    before(:each) do
      FactoryGirl.create_list(:comment, 2)
      session[:logged_in] = true
      get :index
    end

    it("is successful")               { expect(response).to be_success }
    it("renders index template")      { expect(response).to render_template('index') }
    it("finds comments for the view") { expect(assigns[:comments].size).to eq(2) }
  end

  describe 'handling GET to show' do
    before(:each) do
      @comment = Comment.new
      allow(Comment).to receive(:find).and_return(@comment)
      session[:logged_in] = true
      get :show, :id => 1
    end

    it("is successful")              { expect(response).to be_success }
    it("renders show template")      { expect(response).to render_template('show') }
    it("finds comment for the view") { expect(assigns[:comment]).to eq(@comment) }
  end

  describe 'handling PUT to update with valid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      allow(@comment).to receive(:update_attributes).and_return(true)
      allow(Comment).to receive(:find).and_return(@comment)

      @attributes = {'body' => 'a comment'}
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :comment => @attributes
    end

    it("redirects to index") do
      do_put
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_comments_path)
    end

    it("updates comment") do
      expect(@comment).to receive(:update_attributes).with(@attributes).and_return(true)
      do_put
    end

    it("puts a message in the flash") do
      do_put
      expect(flash[:notice]).not_to be_blank
    end
  end

  describe 'handling PUT to update with invalid attributes' do
    before(:each) do
      @comment = mock_model(Comment, :author => 'Don Alias')
      allow(@comment).to receive(:update_attributes).and_return(false)
      allow(Comment).to receive(:find).and_return(@comment)

      @attributes = {:body => ''}
    end

    def do_put
      session[:logged_in] = true
      put :update, :id => 1, :comment => @attributes
    end

    it("renders show") do
      do_put
      expect(response).to render_template('show')
    end

    it("assigns comment for the view") do
      do_put
      expect(assigns(:comment)).to eq(@comment)
    end
  end

  describe 'handling PUT to update with expected whitelisted attributes present' do
    before(:each) do
      @comment = FactoryGirl.create(:comment)
      allow(Comment).to receive(:find).and_return(@comment)
    end

    it 'allows whitelisted attributes as expected' do
      session[:logged_in] = true
      put :update, :id => 1, :comment => {
        'author'       => "Don Alias",
        'author_url'   => "http://example.com",
        'author_email' => "donalias@example.com",
        'body'         => "This is a comment"
      }

      expect(assigns(:comment).author).to eq("Don Alias")
      expect(assigns(:comment).author_url).to eq("http://example.com")
      expect(assigns(:comment).author_email).to eq("donalias@example.com")
      expect(assigns(:comment).body).to eq("This is a comment")
    end
  end

  describe 'handling DELETE to destroy' do
    before(:each) do
      @comment = Comment.new
      allow(@comment).to receive(:destroy)
      allow(Comment).to receive(:find).and_return(@comment)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1
    end

    it("redirects to index") do
      do_delete
      expect(response).to be_redirect
      expect(response).to redirect_to(admin_comments_path)
    end

    it("deletes comment") do
      expect(@comment).to receive(:destroy)
      do_delete
    end
  end

  describe 'handling DELETE to destroy, JSON request' do
    before(:each) do
      @comment = Comment.new(:author => 'xavier')
      allow(@comment).to receive(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
      allow(Comment).to receive(:find).and_return(@comment)
    end

    def do_delete
      session[:logged_in] = true
      delete :destroy, :id => 1, :format => 'json'
    end

    it("deletes comment") do
      expect(@comment).to receive(:destroy_with_undo).and_return(mock_model(UndoItem, :description => 'hello'))
      do_delete
    end

    it("renders json including a description of the comment") do
      do_delete
      expect(JSON.parse(response.body)['undo_message']).to eq('hello')
    end
  end
end
