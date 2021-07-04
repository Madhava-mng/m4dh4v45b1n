# frozen_string_literal: true

require_relative "lib/m4dh4v45b1n/version"

Gem::Specification.new do |spec|
  spec.name = "m4dh4v45b1n"
  spec.version = VERSION
  spec.authors = ["Madhava-mng"]
  spec.email = ["alformint1@gmail.com"]
  spec.summary = "binarys for exploit,scan,enum,brut,fuzz"
  spec.description = "Developed for POC not harm to any one."
  spec.homepage  = "https://github.com/Madhava-mng/m4dh4v45b1n"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage
  spec.files = [
    "lib/m4dh4v45b1n/enum-subdomain.rb",
    "lib/m4dh4v45b1n/version.rb",
    "lib/m4dh4v45b1n/rand-util.rb",
    "lib/m4dh4v45b1n/enum-wordpress-user.rb",
    "lib/m4dh4v45b1n/fuzz-web-dir.rb",
    "lib/m4dh4v45b1n.rb",
    "dict/subdomain.txt",
    "dict/dirs.txt"
  ]
  spec.executables = [
    "enum-subdomain.rb",
    "m4dh4v45b1n.rb",
    "fuzz-web-dir.rb",
    "enum-wordpress-user.rb"
  ]
  spec.require_paths = ["lib"]
  #spec.add_dependency "resolve-replace"
end
