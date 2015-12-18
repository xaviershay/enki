require File.dirname(__FILE__) + '/../spec_helper'

describe NavigationHelper do
  describe '#page_links_for_navigation' do
    it 'should return the expected links' do
      pages = []
      pages << mock_model(Page, :title => 'Page one', :slug => 'page-one')
      pages << mock_model(Page, :title => 'Page two', :slug => 'page-two')
      allow(Page).to receive(:order).and_return(pages)

      expect(page_links_for_navigation.count).to eq(4)
      expect(page_links_for_navigation[0].name).to eq('Home')
      expect(page_links_for_navigation[1].name).to eq('Archives')
      expect(page_links_for_navigation[2].name).to eq('Page one')
      expect(page_links_for_navigation[3].name).to eq('Page two')
    end
  end

  describe '#category_links_for_navigation' do
    it 'should return the expected links, ignoring tags only associated with unpublished posts' do
      published_post1 = Post.create!(:title => 'Published post',
                                     :body => 'This is the post body.',
                                     :tag_list => 'red, green, blue',
                                     :published_at_natural => 'now')

      published_post2 = Post.create!(:title => 'Published post',
                                     :body => 'This is the post body.',
                                     :tag_list => 'red, green',
                                     :published_at_natural => 'now')

      published_post3 = Post.create!(:title => 'Published post',
                                     :body => 'This is the post body.',
                                     :tag_list => 'red',
                                     :published_at_natural => 'now')

      published_post4 = Post.create!(:title => 'Published post',
                                     :body => 'This is the post body.',
                                     :tag_list => ' tag with spaces, another tag with spaces ',
                                     :published_at_natural => 'now')

      unpublished_post = Post.create!(:title => 'Unpublished post',
                                      :body => 'This is the post body.',
                                      :tag_list => 'square, triangle, oblong',
                                      :published_at_natural => '')

      expect(category_links_for_navigation.count).to eq(5)
      expect(category_links_for_navigation[0].name).to eq('red')
      expect(category_links_for_navigation[1].name).to eq('green')
      expect(category_links_for_navigation[2].name).to eq('tag with spaces')
      expect(category_links_for_navigation[3].name).to eq('blue')
      expect(category_links_for_navigation[4].name).to eq('another tag with spaces')
    end
  end
end
