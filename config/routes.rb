require 'redmine_charts/utils'

# Configuring routing for plugin's controllers.

if Rails::VERSION::MAJOR < 3
  ActionController::Routing::Routes.draw do |map|
    RedmineCharts::Utils.controllers_for_routing do |name, controller|
      map.connect "projects/:project_id/charts/#{name}/:action", controller: controller
    end
  end
else
  RedmineApp::Application.routes.draw do
    RedmineCharts::Utils.controllers_for_routing do |name, controller|
      match "projects/:project_id/charts/#{name}/:action", controller: controller, via: [:get]
    end
  end
end
