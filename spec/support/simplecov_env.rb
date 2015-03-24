if RUBY_VERSION >= '1.9'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_group('Charts', 'redmine_charts')
  end
end
