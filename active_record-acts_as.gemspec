# frozen_string_literal: true

require_relative "lib/active_record/acts_as/version"

Gem::Specification.new do |spec|
  spec.name          = "active_record-acts_as"
  spec.version       = ActiveRecord::ActsAs::VERSION
  spec.authors       = ["Hassan Zamani", "Manuel Meurer", "Chedli Bourguiba"]
  spec.email         = ["bourguiba.chedli@gmail.com"]
  spec.summary       = %q{Simulate multi-table inheritance for activerecord models}
  spec.description   = %q{Simulate multi-table inheritance for activerecord models using a polymorphic association}
  spec.homepage      = "http://github.com/chaadow/active_record-acts_as"
  spec.metadata         = {
    "homepage_uri"    => "http://github.com/chaadow/active_record-acts_as",
    "source_code_uri" => "http://github.com/chaadow/active_record-acts_as",
    "changelog_uri"   => "http://github.com/chaadow/active_record-acts_as/blob/master/CHANGELOG.md",
    "bug_tracker_uri" => "http://github.com/chaadow/active_record-acts_as/issues"
  }
  spec.license       = "MIT"

  spec.files         = Dir["README.md", "MIT-LICENSE", "lib/**/*.rb"]

  spec.required_ruby_version = ">= 3.1"

  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "appraisal"
  spec.add_development_dependency "guard-rspec", "~> 4.7"

  spec.add_dependency "activesupport", ">= 6.0"
  spec.add_dependency "activerecord", ">= 6.0"

end
