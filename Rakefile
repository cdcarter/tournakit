require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rdoc/task"
task :default => :spec

RDoc::Task.new do |rd|
	rd.main = "README.md"
  rd.rdoc_files.include("README.md", "lib/**/*.rb")
end
