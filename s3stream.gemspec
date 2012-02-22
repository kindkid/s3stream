# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "s3stream/version"

Gem::Specification.new do |s|
  s.name        = "s3stream"
  s.version     = S3Stream::VERSION
  s.authors     = ["Chris Johnson"]
  s.email       = ["chris@kindkid.com"]
  s.homepage    = ""
  s.summary     = "Stream files on S3 to stdout or from stdin"
  s.description = s.summary

  s.rubyforge_project = "s3stream"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "aws-s3", "~> 0.6.2"
  s.add_runtime_dependency "thor", "~> 0.14.6"
  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "simplecov", "~> 0.4"
  s.add_development_dependency("rb-fsevent", "~> 0.4") if RUBY_PLATFORM =~ /darwin/i
  s.add_development_dependency "guard", "~> 0.5"
  s.add_development_dependency "guard-bundler", "~> 0.1"
  s.add_development_dependency "guard-rspec", "~> 0.4"
end
