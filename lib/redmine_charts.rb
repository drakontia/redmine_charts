#require 'redmine_charts/line_data_converter'
#require 'redmine_charts/pie_data_converter'
#require 'redmine_charts/stack_data_converter'
#require 'redmine_charts/utils'
#require 'redmine_charts/conditions_utils'
#require 'redmine_charts/grouping_utils'
require 'redmine_charts/range_utils'
#require 'redmine_charts/issue_patch'
#require 'redmine_charts/time_entry_patch'

module RedmineCharts
  def self.has_sub_issues_functionality_active
    ((Redmine::VERSION.to_a <=> [1, 0, 0]) >= 0)
  end
end
