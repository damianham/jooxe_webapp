
require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rubygems/package_task'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'yard'

spec = Gem::Specification.new do |s|
  s.name = 'Jooxe'
  s.version = '0.0.1'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE']
  s.summary = 'Jooxe is the zero code web application framework'
  s.description = s.summary
  s.author = 'Damian Hamill'
  s.email = 'damianham@gmail.com'
  # s.executables = ['your_executable_here']
  s.files = %w(LICENSE README Rakefile) + Dir.glob("{bin,lib,spec}/**/*")
  s.require_path = "lib"
  s.bindir = "bin"
end

#Rake::GemPackageTask.new(spec) do |p|
#  p.gem_spec = spec
#  p.need_tar = true
#  p.need_zip = true
#end

#Rake::RDocTask.new do |rdoc|
#  files =['README', 'LICENSE', 'lib/**/*.rb']
#  rdoc.rdoc_files.add(files)
#  rdoc.main = "README" # page to start on
#  rdoc.title = "Jooxe Docs"
#  rdoc.rdoc_dir = 'doc/rdoc' # rdoc output folder
#  rdoc.options << '--line-numbers'
#end

Rake::TestTask.new do |t|
  t.test_files = FileList['test/**/*.rb']
end

desc "Run all examples"
RSpec::Core::RakeTask.new do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  #spec.rspec_opts = [Dir["lib"].to_a.join(':')]
  spec.rspec_opts = %w[--color]
end


YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  #t.options = ['--any', '--extra', '--opts'] # optional
end

Cucumber::Rake::Task.new(:cucumber) do |task|
  task.cucumber_opts = ['--format=progress', 'features']
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:spec, :cucumber]