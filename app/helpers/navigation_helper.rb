module NavigationHelper
  def page_links_for_navigation
    link = Struct.new(:name, :url)
    [link.new("Home", root_path),
     link.new("Archives", archives_path)] +
      Page.order('title').collect { |page| link.new(page.title, page_path(page.slug)) }
  end

  def category_links_for_navigation
    link = Struct.new(:name, :url)
    get_tags_for_published_posts.collect { |tag| link.new(tag.name, posts_path(:tag => tag.name)) }
  end

  private

    def get_tags_for_published_posts
      published_posts = Post.where.not(:published_at => nil)
      published_tag_names = published_posts.collect{ |post|
        unless post.cached_tag_list.nil?
          post.cached_tag_list.split(',')
        end
      }.flatten.uniq
      published_tag_names.each do |tag|
        unless tag.nil?
          tag.strip!
        end
      end
      ActsAsTaggableOn::Tag.where(:name => published_tag_names).sort_by { |tag| tag.taggings.size }.reverse
    end
end
