
require 'rubygems'
require 'rake'
require 'rake/clean'
require 'rake/testtask'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'yard'

if ENV['RUBY_VERSION'] =~ /^jruby/
  load "lib/tasks/schema_java.rake"
else
  load "lib/tasks/schema.rake"
end

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