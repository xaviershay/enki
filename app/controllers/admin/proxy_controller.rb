require 'net/http'
require 'uri'

class Admin::ProxyController < Admin::BaseController
  layout nil

  def index
    url = URI.parse(params[:id])
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get(url.path)
    }
    response.headers['Content-Type'] = res['content-type']
    render :text => res.body
  end
end
