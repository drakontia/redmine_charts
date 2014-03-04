gem 'ofc2'
if ENV['RAILS_ENV'] == 'test'
  Dir.glob File.expand_path("../plugins/redmine_charts/Gemfile.local", __FILE__) do |file|
    puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
    #TODO: switch to "eval_gemfile file" when bundler >= 1.2.0 will be required (rails 4)
    instance_eval File.read(file), file
  end
end
