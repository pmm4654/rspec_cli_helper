
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec_cli_helper/version"

Gem::Specification.new do |spec|
  spec.name          = "rspec_cli_helper"
  spec.version       = RspecCliHelper::VERSION
  spec.authors       = ["Patrick MacMurchy"]
  spec.email         = ["pmm4654@gmail.com"]

  spec.summary       = %q{A CLI to help you write auto-tests}
  spec.description   = %q{The goal of this gem is to provide an interactive experience to help you write auto-tests for existing code (sorry, TDD). }
  spec.homepage      = "https://github.com/pmm4654/rspec_cli_helper"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "parser"
  spec.add_dependency "tty-prompt"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
end
