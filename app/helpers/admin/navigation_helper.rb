module Admin::NavigationHelper
  def nav_link_to(text, url, options)
    options.merge!(:class => 'current') if url == request.request_uri
    link_to(text, url, options)
  end
end
