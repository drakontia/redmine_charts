# A sample Guardfile
# More info at https://github.com/guard/guard#readme

if RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/
  notification :notifu, :time => 5, :nosound => true, :xp => true
  interactor :off
end

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false, :cucumber => false, :wait => 30 do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('plugins/redmine_charts/Gemfile')
  watch('plugins/redmine_charts/Gemfile.local')
  watch('plugins/redmine_charts/Gemfile.lock')
  watch('plugins/redmine_charts/spec/spec_helper.rb') { :rspec }
end

guard 'rspec', cmd: 'bundle exec rspec --color --drb --f doc' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^plugins/redmine_charts/spec/.+_spec\.rb$})
  watch(%r{^plugins/redmine_charts/lib/redmine_charts/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('plugins/redmine_charts/spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^plugins/redmine_charts/app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^plugins/redmine_charts/app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^plugins/redmine_charts/app/controllers/(.+)_(controller)\.rb$})  { "spec/features" }
  watch(%r{^plugins/redmine_charts/spec/support/(.+)\.rb$})                  { "spec" }
  watch('plugins/redmine_charts/config/routes.rb')                           { "spec/features" }

  # Capybara features specs
  watch(%r{^plugins/redmine_charts/app/views/(.+)/.*\.(erb|haml)$})          { "spec/features" }

end
