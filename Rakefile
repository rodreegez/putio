require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
task :default => :test

task :install do
  %x|gem install putio|
end

task :uninstall do
  %x|gem uninstall putio|
end

task :build do 
  %x|gem build putio.gemspec|
end

task :reinstall => [:uninstall, :build, :install]
