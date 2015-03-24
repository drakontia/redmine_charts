# Sets up the Rails environment for Cucumber
ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
# require 'cucumber/rails/world'
# Cucumber::Rails::World.use_transactional_fixtures
require 'active_support/time'

class Time
  def self.set_current_date=(date)
    @date = date
  end

  def self.now
    @date || Time.mktime(2010, 3, 11)
  end
end

if Rails::VERSION::MAJOR >= 3
  require 'rspec/rails/matchers'
  # World(Rspec::Rails::Matchers::RoutingMatchers)
end

# Seed the DB
def seed_the_database
  fixtures = ActiveRecord::FixtureSet
  # Before do # a little longer, but more reliable
  self.seed_the_database_with(fixtures)
  # end
end

def seed_the_database_with(fixtures)
  fixtures.reset_cache
  fixtures_folder = File.join(Rails.root, 'spec', 'fixtures')
  fixtures_files = Dir[File.join(fixtures_folder, '*.yml')].map { |f| File.basename(f, '.yml') }
  fixtures.create_fixtures(fixtures_folder, fixtures_files)
end

self.seed_the_database

# if Cucumber::Rails.respond_to?('Database')
# only for recent cucumber-rails
# do not clean the database between @javascript scenarios
# Cucumber::Rails::Database.javascript_strategy = :transaction
# end
# DatabaseCleaner.strategy = nil # much faster than truncation

# use headless webkit to test javascript ui
# require 'capybara/poltergeist'
# Capybara.javascript_driver = :poltergeist
# Capybara.register_driver :poltergeist do |app|
#  Capybara::Poltergeist::Driver.new(app, :inspector => true)
# end

if Rails::VERSION::MAJOR >= 3
  require 'rake'
  require 'rails/tasks'
  Rake::Task['tmp:create'].invoke
end
