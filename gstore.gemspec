# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gstore}
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Richard Taylor"]
  s.date = %q{2010-07-19}
  s.description = %q{gstore is a Ruby client library for the Google Storage API.}
  s.email = %q{moomerman@gmail.com}
  s.files = ["LICENSE", "README.textile","lib/gstore.rb"] + Dir.glob('lib/gstore/*.rb')
  s.has_rdoc = false
  s.homepage = %q{http://github.com/moomerman/gstore}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{gstore}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{gstore is a Ruby client library for the Google Storage API.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      #s.add_runtime_dependency(%q<oauth>, [">= 0.3.6"])
      #s.add_development_dependency dep
    else
      #s.add_dependency(%q<oauth>, [">= 0.3.6"])
    end
  else
    #s.add_dependency(%q<oauth>, [">= 0.3.6"])
  end
end
