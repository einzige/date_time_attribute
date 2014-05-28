# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{date_time_attribute}
  s.version = "0.1.2"

  s.date = %q{2013-11-22}
  s.authors = ["Sergei Zinin", "Robert Gauld"]
  s.email = %q{szinin@gmail.com}
  s.homepage = %q{http://github.com/einzige/date_time_attribute}

  s.licenses = ["MIT"]

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.extra_rdoc_files = ["README.md"]

  s.description = %q{Allows you to work with the date and time parts of DateTime attributes separately. Plays with time zones and ActiveModel as well.}
  s.summary = %q{Splits DateTime attribute access into separate Date, Time and TimeZone attributes}

  s.add_runtime_dependency 'activesupport', ">= 3.0.0"
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'activerecord', ">= 4.0.2"
end
