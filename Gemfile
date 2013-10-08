if ENV['RAILS_ENV'] == 'test'
  Dir.glob File.expand_path("../plugins/redmine_charts/Gemfile.local", __FILE__) do |file|
    puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
    eval_gemfile file
  end
end
