module NavigationHelper
  def page_links_for_navigation
    link = Struct.new(:name, :url)
    [link.new("Home", posts_path)] + 
      Page.find(:all, :order => 'title').collect {|page| link.new(page.title, page_path(page))}
  end
end
