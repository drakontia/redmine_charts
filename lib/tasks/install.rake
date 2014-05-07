require 'fileutils'

namespace :redmine do
  namespace :charts do
    task :install => :environment do
      public_path = Rails.root.join("public")
      p public_path
      ofc2_path = %x{bundle exec gem which ofc2}.to_s
      p File.dirname(ofc2_path)

      unless File.exist?(public_path.to_s + "/assets/")
        FileUtils.mkdir(public_path.to_s + "/assets/")
      end
      Dir.glob(File.dirname(ofc2_path).to_s + "/../app/assets/**/*.*").each {|file|
          p file
        if File.extname(file) == ".js"
          FileUtils.copy(file, (public_path.to_s + "/javascripts/"))
        elsif File.extname(file) == ".swf"
          FileUtils.copy(file, (public_path.to_s + "/assets/"))
        end
      }

      #Rake::Task["redmine:charts:migrate"].invoke
    end
  end
end
