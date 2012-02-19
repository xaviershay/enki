# Many moons ago, I modified this plugin to not use a polymorphic association.
# Well-intentioned, but not a good way to achieve it. In hindsight, should not
# have dependend on this plugin in the first place since it doesn't really
# provide much benefit to this project.
#
# Anyway, as a result, we can't depend on any newer gem versions and have to
# include this in the source tree.
$LOAD_PATH.unshift(File.expand_path('../../../lib/acts_as_taggable_on_steroids/lib', __FILE__))
require 'acts_as_taggable_on_steroids/init'
require 'tag_list'
require 'tags_helper'
