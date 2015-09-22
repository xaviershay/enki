require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::HealthController do
  describe 'handling GET to index' do
    before(:each) do
      session[:logged_in] = true
      get :index
    end

    it "is successful" do
      expect(response).to be_success
    end

    it "renders health template" do
      expect(response).to render_template("index")
    end
  end

  describe 'handling POST to generate_exception' do
    describe 'when logged in' do
      it 'raises a RuntimeError' do
        session[:logged_in] = true
        expect {
          post :generate_exception
        }.to raise_error RuntimeError
      end
    end

    describe 'when not logged in' do
      it 'does not raise' do
        expect {
          post :generate_exception
        }.not_to raise_error
      end
    end
  end

  describe 'handling GET to generate_exception' do
    it '405s' do
      session[:logged_in] = true
      get :generate_exception
      expect(response.status).to eq(405)
      expect(response.headers['Allow']).to eq('POST')
    end
  end
end
