module RedmineCharts
  module GroupingUtils
    include Redmine::I18n

    @@types = [:user_id, :issue_id, :activity_id, :category_id, :tracker_id, :fixed_version_id, :priority_id, :author_id, :status_id, :project_id, :assigned_to_id]

    def self.types
      @@types
    end

    def self.from_params(types, params)
      if params[:grouping].blank? or not types.include?(params[:grouping].to_sym)
        nil
      else
        params[:grouping].to_sym
      end
    end

    def self.to_options(options)
      options.map { |i| [l("charts_group_by_#{i}".to_sym), i]  }
    end

    def self.to_string(id, grouping, default = nil)
      if grouping.nil? or grouping == :none
        l(:charts_group_all)
      elsif grouping == :category_id and category = IssueCategory.find_by_id(id.to_i)
        category.name
      elsif [:user_id, :author_id, :assigned_to_id].include? grouping and user = User.find_by_id(id.to_i)
        "#{user.name}"
      elsif grouping == :issue_id and issue = Issue.find_by_id(id.to_i)
        subject = issue.subject
        if subject.length > 24
          subject = "#{subject[0, 20].strip} ..."
        end
        "##{issue.id} #{subject}"
      elsif grouping == :project_id and project = Project.find_by_id(id.to_i)
        name = project.name
        if name.length > 24
          name = "#{name[0, 20].strip} ..."
        end
        "##{project.id} #{name}"
      elsif grouping == :activity_id and activity = TimeEntryActivity.find_by_id(id.to_i)
        activity.name
      elsif grouping == :priority_id and priority = IssuePriority.find_by_id(id.to_i)
        priority.name
      elsif grouping == :tracker_id and tracker = Tracker.find_by_id(id.to_i)
        tracker.name
      elsif grouping == :fixed_version_id and version = Version.find_by_id(id.to_i)
        version.name
      elsif grouping == :status_id and status = IssueStatus.find_by_id(id.to_i)
        status.name
      elsif default
        default
      else
        l(:charts_group_none)
      end
    end

    def self.to_column(symbol, table)
      case symbol
      when :user_id then "#{table}.user_id"
      when :author_id then 'issues.author_id'
      when :assigned_to_id then 'issues.assigned_to_id'
      when :issue_id then "#{table}.issue_id"
      when :activity_id then "#{table}.activity_id"
      when :category_id then 'issues.category_id'
      when :priority_id then 'issues.priority_id'
      when :tracker_id then 'issues.tracker_id'
      when :fixed_version_id then 'issues.fixed_version_id'
      when :project_id then "#{table}.project_id"
      when :status_id then 'issues.status_id'
      end
    end
  end
end
