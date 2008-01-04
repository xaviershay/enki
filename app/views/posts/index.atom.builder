atom_feed(
  :url         => url_for(:format => 'atom', :only_path => false), 
  :root_url    => url_for(:only_path => false),
  :schema_date => '2008'
) do |feed|
  feed.title     posts_title(@tag)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:updated_at).max
  feed.generator "Roboblog", "uri" => "http://roboblog.com"

  feed.author do |xml|
    xml.name  author.name
    xml.email author.email unless author.email.nil?
  end

  @posts.each do |post|
   feed.entry(post, :url => post_path(post)) do |entry|
      entry.title   post.title
      entry.content post.body_html, :type => 'html'
    end
  end
end
