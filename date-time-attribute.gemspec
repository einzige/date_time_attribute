# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{date-time-attribute}
  s.version = "0.0.1"

  s.date = %q{2013-11-22}
  s.authors = ["Sergei Zinin"]
  s.email = %q{szinin@gmail.com}
  s.homepage = %q{http://github.com/einzige/date-time-attribute}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Allows to assign date and time attributes separately for a DateTime attribute in your class/model.}
  s.summary = %q{Splits DateTime attribute access into two separate Data and Time attributes}

  s.add_runtime_dependency 'activesupport', ">= 3.0.12"
  s.add_development_dependency 'bundler'
end
