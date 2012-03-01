require "bundler/gem_tasks"

desc "Open development console"
task :console do
  puts "Loading development console..."
  system "pry -I #{File.join('.', 'lib')} -r #{File.join('.', 'lib', 's3stream')}"
end
