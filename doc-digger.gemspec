# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'doc-digger/version'

Gem::Specification.new do |spec|
  spec.name          = "doc-digger"
  spec.version       = DocDigger::VERSION
  spec.authors       = ["wootaw"]
  spec.email         = ["wootaw@gmail.com"]

  spec.summary       = "This gem generate RESTful web API documentation."
  spec.description   = "DocDigger is a tool for generating RESTful web API documentation by analyzing block comments in source code."
  spec.homepage      = "https://github.com/wootaw/doc-digger"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = ""
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.post_install_message = "Thanks for installing!"

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rspec-nc", '~> 0'
  spec.add_development_dependency "awesome_print", '~> 1.7'
  spec.add_development_dependency "guard", '~> 2'
  spec.add_development_dependency "guard-rspec", '~> 4'
  spec.add_development_dependency "pry", '~> 0'
  spec.add_development_dependency "pry-remote", '~> 0'
  spec.add_development_dependency "pry-nav", '~> 0'
  spec.add_development_dependency "codeclimate-test-reporter", '~> 0.4.8'
  spec.add_development_dependency "git", '~> 1'
end
