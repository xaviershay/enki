require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/contrib/rubyforgepublisher'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the defensio plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the defensio plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Defensio'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :pub_doc => :rdoc do
  Rake::SshDirPublisher.new("macournoyer@macournoyer.com",
                            "code.macournoyer.com/defensio",
                            "rdoc").upload
end