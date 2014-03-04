require 'redmine'

require 'ofc2'
require 'redmine_charts'

Rails.logger.info 'Starting Charts Plugin for RedMine'
Rails.configuration.to_prepare do
  require_dependency 'issue'
  require_dependency 'time_entry'

  unless Issue.included_modules.include? RedmineCharts::IssuePatch
    Issue.send(:include, RedmineCharts::IssuePatch)
  end

  unless TimeEntry.included_modules.include? RedmineCharts::TimeEntryPatch
    TimeEntry.send(:include, RedmineCharts::TimeEntryPatch)
  end
end

Redmine::Plugin.register :redmine_charts do
  name 'Redmine Charts'
  author 'Daisuke Miura'
  description 'Plugin for Redmine which integrates some nice project charts.'
  url 'http://github.com/drakontia/redmine_charts/'
  version File.read(File.dirname(__FILE__) + '/VERSION').strip

  # Minimum version of Redmine.

  requires_redmine :version_or_higher => '2.0.0'

  # Configuring permissions for plugin's controllers.

  project_module :charts do
    permission :view_charts, RedmineCharts::Utils.controllers_for_permissions, :require => :member
    permission :save_charts, {:charts_saved_condition => [:create, :edit, :destroy]}, :require => :member
  end

  # Creating menu entry. It appears in project menu, after 'new_issue' entry.

  menu :project_menu, :charts, { :controller => RedmineCharts::Utils.default_controller, :action => 'index' }, :caption => :charts_menu_label, :after => :new_issue, :param => :project_id
end
