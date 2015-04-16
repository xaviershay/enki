class OmniAuthDetails < ActiveRecord::Base
	serialize :info, Hash
	serialize :credentials, Hash
	serialize :extra, Hash
end
