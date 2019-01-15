lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "routable_setting/version"

Gem::Specification.new do |spec|
  spec.name          = "routable_setting"
  spec.version       = RoutableSetting::VERSION
  spec.authors       = ["Dan Thomas"]
  spec.email         = ["dan@ideacrew.com"]

  spec.summary       = %q{Manage application settings in distributed database tables and read into cache}
  spec.description   = %q{Define configuration key/value pairs local to Rails Apps, Engines and Gems}
  spec.homepage      = "https://github.com/dchbx/routable_setting.git"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/dchbx/routable_setting.git"
    spec.metadata["changelog_uri"] = "https://raw.githubusercontent.com/dchbx/routable_setting/master/CHANGEFILE.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency 'rails', '~> 5.0'

  # spec.add_development_dependency "bundler", "~> 2.0"
  # spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency 'rails', '4.2.7.1'
  spec.add_dependency 'mongoid', '~> 5.4.0'
  # spec.add_dependency 'pry'
  spec.add_runtime_dependency 'pry'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rspec", "~> 3.0"

  # spec.add_dependency 'rails', '4.2.7.1'
  spec.add_dependency 'mongoid', '~> 5.4.0'

  # spec.add_development_dependency "bundler", "~> 1.10"
  # spec.add_development_dependency "rake", "~> 10.0"
  # spec.add_development_dependency "rspec"
end
