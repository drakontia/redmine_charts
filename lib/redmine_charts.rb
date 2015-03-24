def apply_patch(&block)
ActionDispatch::Callbacks.to_prepare(&block)
end

apply_patch do

  rbfiles = Rails.root.join('plugins', 'redmine_charts', 'lib', 'open_flash_chart', '*.rb')
  Dir.glob(rbfiles).each do |file|
    require_dependency file
  end

  require_dependency 'issue'
  require_dependency 'time_entry'

  unless Issue.included_modules.include? RedmineCharts::IssuePatch
    Issue.send(:include, RedmineCharts::IssuePatch)
  end

  unless TimeEntry.included_modules.include? RedmineCharts::TimeEntryPatch
    TimeEntry.send(:include, RedmineCharts::TimeEntryPatch)
  end
end

require 'redmine_charts/line_data_converter'
require 'redmine_charts/pie_data_converter'
require 'redmine_charts/stack_data_converter'
require 'redmine_charts/utils'
require 'redmine_charts/conditions_utils'
require 'redmine_charts/grouping_utils'
require 'redmine_charts/range_utils'
require 'redmine_charts/issue_patch'
require 'redmine_charts/time_entry_patch'

module RedmineCharts
  def self.has_sub_issues_functionality_active
    ((Redmine::VERSION.to_a <=> [1, 0, 0]) >= 0)
  end
end
