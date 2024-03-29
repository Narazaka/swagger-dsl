lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "swagger/dsl/version"

Gem::Specification.new do |spec|
  spec.name = "swagger-dsl"
  spec.version = Swagger::DSL::VERSION
  spec.authors = %w[Narazaka]
  spec.email = %w[info@narazaka.net]
  spec.licenses = %w[Zlib]

  spec.summary = "Swagger (OpenAPI 3) DSL"
  spec.homepage = "https://github.com/Narazaka/swagger-dsl"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/Narazaka/swagger-dsl.git"
  spec.metadata["changelog_uri"] = "https://github.com/Narazaka/swagger-dsl/blob/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://www.rubydoc.info/gems/#{spec.name}/#{spec.version}"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files =
    Dir.chdir(File.expand_path("..", __FILE__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_dependency "jimmy", "~> 0.5"
  spec.add_dependency "json-schema-subset-dsl", "~> 2.0"
  spec.add_dependency "hana", "~> 1.3"
  spec.add_dependency "json_refs", "~> 0.1"
  spec.add_dependency "activesupport", ">= 4.0.2"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rspec-power_assert", "~> 1.1"
  spec.add_development_dependency "rubocop", "~> 0.76"
  spec.add_development_dependency "rubocop-airbnb", "~> 3"
  spec.add_development_dependency "prettier", ">= 0.16"
  spec.add_development_dependency "rubocop-config-prettier", "~> 0.1"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "pry-byebug", "~> 3.7"
  spec.add_development_dependency "json_spec", "~> 1"
  spec.add_development_dependency "openapi3_parser", "~> 0.9.1"
end
