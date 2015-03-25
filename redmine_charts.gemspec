# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = 'redmine_charts'
  s.version = '0.2.1'
  s.date = '2015-03-31'

  s.authors = ['Daisuke Miura']
  s.email = 'mhden@drakontia.com'
  s.homepage = 'http://github.com/drakontia/redmine_charts/'
  s.summary = %q{Chart plugin for Redmine}
  s.description = %q{Plugin for Redmine which integrates some nice project charts.}

  s.extra_rdoc_files = ['LICENSE',
                        'README.markdown']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-activemodel-mocks'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'timecop'

end
