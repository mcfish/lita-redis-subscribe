Gem::Specification.new do |spec|
  spec.name          = "lita-redis-subscribe"
  spec.version       = "0.0.2"
  spec.authors       = ["ata.1213"]
  spec.email         = ["ata.1213@gmail.com"]
  spec.description   = %q{A Lita handler for subscribe to redis}
  spec.summary       = %q{A Lita handler for subscribe to redis}
  spec.homepage      = "https://github.com/mcfish/lita-redis-subscribe"
  spec.license       = "MIT"
  spec.metadata      = { "lita_plugin_type" => "handler" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
