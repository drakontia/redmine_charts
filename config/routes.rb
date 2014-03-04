require 'redmine_charts/utils'

# Configuring routing for plugin's controllers.
RedmineApp::Application.routes.draw do
  RedmineCharts::Utils.controllers_for_routing do |name, controller|
    match "projects/:project_id/charts/#{name}/:action", :to => controller, :via => [:get]
  end
end
