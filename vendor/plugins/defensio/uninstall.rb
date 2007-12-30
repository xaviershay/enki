require 'fileutils'
config_file = "#{RAILS_ROOT}/config/defensio.yml"
FileUtils.rm config_file if File.exist? config_file