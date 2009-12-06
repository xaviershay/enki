class Tag < ActiveRecord::Base
  has_many                :taggings, :dependent => :destroy

  validates_presence_of   :name
  validates_uniqueness_of :name

  # TODO: Contribute this back to acts_as_taggable_on_steroids plugin
  # Update taggables' cached_tag_list
  after_destroy do |tag|
    tag.taggings.each do |tagging|
      taggable = tagging.taggable
      if taggable.class.caching_tag_list?
        taggable.tag_list = TagList.new(*taggable.tags.map(&:name))
        taggable.save
      end
    end
  end

  cattr_accessor :destroy_unused
  self.destroy_unused = false

  # LIKE is used for cross-database case-insensitivity
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end

  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end

  def to_s
    name
  end

  def count
    read_attribute(:count).to_i
  end
end
