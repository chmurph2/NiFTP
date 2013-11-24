require 'bundler'
require 'rake/testtask'

desc 'Default: run unit tests.'
task :default => :test

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end