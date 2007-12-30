require 'fileutils'
FileUtils.cp "#{File.dirname(__FILE__)}/example/defensio.yml", "#{RAILS_ROOT}/config/defensio.yml"
puts File.read("#{File.dirname(__FILE__)}/README")