Gem::Specification.new do |s|
  s.name = %q{quality_assignable}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Justin Leitgeb"]
  s.date = %q{2009-06-17}
  s.description = %q{Enables a quality metric to be assigned to an AR-backed class or attribute}
  s.email = %q{justin@phq.org}
  
  s.files = ["lib/quality_assignable/attribute.rb", "lib/quality_assignable/constants.rb", "lib/quality_assignable.rb", "LICENSE", "quality_assignable.gemspec", "Rakefile", "README.rdoc", "spec/quality_assignable/attribute_spec.rb", "spec/quality_assignable_spec.rb", "spec/spec_helper.rb"]
  
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jsl/quality_assignable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{ Enables a quality metric to be assigned to an AR-backed class or attribute }
  s.test_files = ["spec/quality_assignable/attribute_spec.rb", "spec/quality_assignable_spec.rb", "spec/spec_helper.rb"]

  s.extra_rdoc_files = [ "README.rdoc" ]
  
  s.rdoc_options += [
    '--title', 'Quality Assignable',
    '--main', 'README.rdoc',
    '--line-numbers',
    '--inline-source'
   ]

  %w[ activerecord activesupport ].each do |dep|
    s.add_dependency(dep)
  end

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2
  end
end
