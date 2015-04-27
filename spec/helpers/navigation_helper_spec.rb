require File.dirname(__FILE__) + '/../spec_helper'

describe NavigationHelper do
  describe '#page_links_for_navigation' do
    it 'should return the expected links' do
      pages = []
      pages << mock_model(Page, :title => 'Page one')
      pages << mock_model(Page, :title => 'Page two')
      Page.stub(:order).and_return(pages)

      page_links_for_navigation.count.should == 4
      page_links_for_navigation[0].name.should == 'Home'
      page_links_for_navigation[1].name.should == 'Archives'
      page_links_for_navigation[2].name.should == 'Page one'
      page_links_for_navigation[3].name.should == 'Page two'
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

      category_links_for_navigation.count.should == 5
      category_links_for_navigation[0].name.should == 'red'
      category_links_for_navigation[1].name.should == 'green'
      category_links_for_navigation[2].name.should == 'tag with spaces'
      category_links_for_navigation[3].name.should == 'blue'
      category_links_for_navigation[4].name.should == 'another tag with spaces'
    end
  end
end
