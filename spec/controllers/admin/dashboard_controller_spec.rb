require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::DashboardController do
  describe 'handling GET to show' do
    before(:each) do
      @posts    = [mock_model(Post), mock_model(Post)]
      @comment_activity = [double("comment-1"), double("comment-2")]
      allow(Post).to receive(:find_recent).and_return(@posts)
      allow(Stats).to receive(:new).and_return(@stats = Struct.new(:post_count, :comment_count, :tag_count).new(3,2,1))

      allow(CommentActivity).to receive(:find_recent).and_return(@comment_activity)

      session[:logged_in] = true
      get :show
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders show template" do
      expect(response).to render_template('show')
    end

    it "finds posts for the view" do
      expect(assigns[:posts]).to eq(@posts)
    end

    it "assigns stats for the view" do
      expect(assigns[:stats]).to eq(@stats)
    end

    it "finds comment activity for the view" do
      expect(assigns[:comment_activity]).to eq(@comment_activity)
    end
  end
end
