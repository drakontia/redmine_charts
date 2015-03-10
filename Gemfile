if ENV['RAILS_ENV'] == 'test'
  Dir.glob File.expand_path("../Gemfile.local", __FILE__) do |file|
    #puts "Loading #{file} ..." if $DEBUG # `ruby -d` or `bundle -v`
    puts "Loading #{file} ..." # `ruby -d` or `bundle -v`
    eval_gemfile file
  end
end
