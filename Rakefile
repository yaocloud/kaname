require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV['RACK_ENV'] = 'test'

  t.libs << "test"
  t.test_files = FileList['test/test_*.rb']
end

task(default: :test)
