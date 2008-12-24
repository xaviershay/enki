$:.unshift(RAILS_ROOT + '/vendor/cucumber-0.1.13/lib')
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format progress"
end
task :features => 'db:test:prepare'
