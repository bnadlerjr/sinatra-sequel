# frozen_string_literal: true

require_relative 'lib/sinatra/sequel/version'

Gem::Specification.new do |spec|
  spec.name = 'sinatra-sequel'
  spec.version = Sinatra::Sequel::VERSION
  spec.authors = ['Bob Nadler']
  spec.email = ['bnadlerjr@gmail.com']

  spec.summary = 'Write a short summary, because RubyGems requires one.'
  spec.homepage = 'https://github.com/bnadlerjr/sinatra-sequel'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['changelog_uri'] = 'http://example.com'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['source_code_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (__FILE__ == f) || f.match(%r{\A(?:(?:spec|features)/|\.(?:git|circleci))})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.24'
  spec.add_development_dependency 'rubocop-performance', '~> 1.13'
  spec.add_development_dependency 'rubocop-rake', '~> 0.6'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.7'
end
