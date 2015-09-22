url = if @tag.nil?
  formatted_posts_path(:format => 'atom', :full_url => true)
else
  posts_path(:tag => @tag, :format => 'atom', :full_url => true)
end

atom_feed(
  :url         => url,
  :root_url    => posts_path(:tag => @tag, :full_url => true),
  :schema_date => '2008'
) do |feed|
  feed.title     posts_title(@tag)
  feed.updated   @posts.empty? ? Time.now.utc : @posts.collect(&:edited_at).max
  feed.generator "Enki", "uri" => "http://enkiblog.com"

  feed.author do |xml|
    xml.name  author.name
    xml.email author.email unless author.email.nil?
  end

  @posts.each do |post|
   feed.entry(post, :url => post_path(post, :full_url => true), :published => post.published_at, :updated => post.edited_at) do |entry|
      entry.title   post.title
      entry.content post.body_html, :type => 'html'
    end
  end
end
