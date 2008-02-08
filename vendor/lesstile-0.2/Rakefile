# -*- ruby -*-

require 'rubygems'
require 'hoe'
require 'spec/rake/spectask'
require './lib/lesstile.rb'

Hoe.new('lesstile', Lesstile::VERSION) do |p|
  p.rubyforge_name = 'lesstile'
  p.author = 'Xavier Shay'
  p.email = 'xavier@rhnh.net'
  p.summary = 'Format text using an exceedingly simple markup language - perfect for comments on your blog'
  p.description = p.paragraphs_of('README.txt', 2..5).join("\n\n")
  p.url = p.paragraphs_of('README.txt', 0).first.split(/\n/)[1..-1]
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.remote_rdoc_dir = ""
end

Spec::Rake::SpecTask.new do |t|
  t.warning = false
  t.rcov = false
  t.spec_files = FileList['spec/spec_*.rb']
end

task :test => :spec
# vim: syntax=Ruby
