class ChartsDeviationController < ChartsController
  unloadable

  protected

  def get_data
    rows = ChartTimeEntry.get_aggregation(:issue_id, @conditions)

    done_ratios = ChartDoneRatio.get_aggregation_for_issue(@conditions)

    rows.sort! do |row1, row2|
      row1.group_id <=> row2.group_id
    end

    labels = []
    max = 0

    total_logged_hours = 0
    total_estimated_hours = 0
    total_remaining_hours = 0
    total_done_ratio = 0
    total_remaining_ratio = 0
    total_logged_ratio = 0

    logged_values = []
    remaining_values = []

    logged_hours_for_not_estimated_issues = 0

    issues_tree = {}

    issues_roots = 0

    rows.each_with_index do |row, _index|
      unless row.group_id == 0
        issues_tree[row.group_id] = { logged_hours: row.logged_hours.to_f, original_logged_hours: row.logged_hours.to_f, parent_id: row.parent_id }
        issues_roots += 1 if row.parent_id.nil? and row.estimated_hours.to_i > 0
      end
    end

    issues_tree.each do |_id, entry|
      if entry[:parent_id]
        add_logged_hours_to_parent_issue(issues_tree, entry[:parent_id], entry[:original_logged_hours])
      end
    end

    rows.each_with_index do |row, index|
      unless row.estimated_hours.to_i > 0
        logged_hours_for_not_estimated_issues += issues_tree[row.group_id][:logged_hours]
        next
      end

      remaining_value = nil
      logged_value = nil

      labels << l(:charts_deviation_label,  issue_id: row.group_id)

      logged_ratio = get_logged_ratio(issues_tree[row.group_id][:logged_hours], row.estimated_hours)

      done_ratio = done_ratios[row.group_id.to_i] || 0

      if done_ratio == 100
        remaining_ratio = 0
        remaining_hours = 0
      elsif done_ratio == 0
        remaining_ratio = 100
        remaining_hours = row.estimated_hours.to_i
      else
        remaining_ratio = get_remaining_ratio(logged_ratio, done_ratio)
        remaining_hours = get_remaining_hours(issues_tree[row.group_id][:logged_hours], row.estimated_hours, logged_ratio, remaining_ratio)
      end

      if logged_ratio > 0
        hint = get_logged_hint(logged_ratio, remaining_ratio, done_ratio, issues_tree[row.group_id][:logged_hours], row.estimated_hours, row)
        logged_value = [logged_ratio, hint]
      end

      if remaining_ratio > 0
        hint = get_remaining_hint(logged_ratio, remaining_ratio, done_ratio, issues_tree[row.group_id][:logged_hours], remaining_hours, row.estimated_hours, row)
        remaining_value = [remaining_ratio, hint]
      end

      if remaining_value or logged_value
        logged_values << logged_value
        remaining_values << remaining_value

        if row.root_id == row.group_id
          total_logged_hours += issues_tree[row.group_id][:logged_hours]
          total_estimated_hours += row.estimated_hours.to_f
          total_logged_ratio += logged_ratio
          total_remaining_hours += remaining_hours
          total_remaining_ratio += remaining_ratio
          total_done_ratio += done_ratio.to_f
        end

        max = remaining_ratio + logged_ratio if max < remaining_ratio + logged_ratio
      else
        labels.delete_at(index)
      end
    end

    # Project logged and remaining ratio.
    if labels.size > 0
      issues_roots = 1 if issues_roots == 0
      project_done_ratio = total_done_ratio.to_f / issues_roots
      project_logged_ratio = total_logged_ratio.to_f / issues_roots
      project_remaining_ratio = total_remaining_ratio.to_f / issues_roots
    else
      project_done_ratio = 0
      project_logged_ratio = 0
      project_remaining_ratio = 0
    end

    hint = get_logged_hint(project_logged_ratio, project_remaining_ratio, project_done_ratio, total_logged_hours, total_estimated_hours)
    project_logged_value = [project_logged_ratio, hint]

    hint = get_remaining_hint(project_logged_ratio, project_remaining_ratio, project_done_ratio, total_logged_hours, total_remaining_hours, total_estimated_hours)
    project_remaining_value = [project_remaining_ratio, hint]

    @page = @pagination[:page]
    @pages = (labels.size.to_f / @pagination[:per_page]).ceil

    offset = @pagination[:per_page] * (@pagination[:page] - 1)
    limit = offset + @pagination[:per_page] - 1

    labels = labels[offset..limit]
    logged_values = logged_values[offset..limit]
    remaining_values = remaining_values[offset..limit]

    if labels.nil? or labels.empty?
      { error: :charts_error_no_data }
    else
      labels.unshift(l(:charts_deviation_project_label))
      logged_values.unshift(project_logged_value)
      remaining_values.unshift(project_remaining_value)

      sets = [
        [l(:charts_deviation_group_logged), logged_values],
        [l(:charts_deviation_group_remaining), remaining_values]
      ]

      if logged_hours_for_not_estimated_issues > 0
        if total_logged_hours.to_f + total_remaining_hours.to_f > 0
          value = logged_hours_for_not_estimated_issues.to_f / (total_logged_hours.to_f + total_remaining_hours.to_f) * 100
        else
          value = 100
        end
        values = []
        values << [value, l(:charts_deviation_hint_logged_not_estimated,  logged_hours: RedmineCharts::Utils.round(logged_hours_for_not_estimated_issues))]
        (labels.size - 1).times { values << nil }
        sets << [l(:charts_deviation_group_logged_not_estimated), values]
      end

      {
        labels: labels,
        count: labels.size,
        max: max > 100 ? max : 100,
        sets: sets,
        horizontal_line: 100
      }
    end
  end

  def get_title
    l(:charts_link_deviation)
  end

  def get_help
    l(:charts_deviation_help)
  end

  def get_type
    :stack
  end

  def get_x_legend
    l(:charts_deviation_x)
  end

  def get_y_legend
    l(:charts_deviation_y)
  end

  def get_x_axis_labels
    0
  end

  def show_date_condition
    false
  end

  def get_multiconditions_options
    [:project_ids]
  end

  def show_pages
    true
  end

  private

  def add_logged_hours_to_parent_issue(issues_tree, id, logged_hours)
    return if issues_tree.nil? or issues_tree[id].nil?

    issues_tree[id][:logged_hours] += logged_hours

    if issues_tree[id][:parent_id]
      add_logged_hours_to_parent_issue(issues_tree, issues_tree[id][:parent_id], logged_hours)
    end
  end

  # Ratio of logged to estimated hours.
  #
  # Logged hours: 4h
  # Estimated hours: 10h
  # Logged ratio: 4/10*100 = 40
  #
  def get_logged_ratio(logged_hours, estimated_hours)
    if estimated_hours
      logged_hours.to_f / estimated_hours.to_f * 100
    else
      0
    end
  end

  # Ratio of remaining hours depending on logged hours.
  #
  # Done ratio: 40% (logged by users)
  # Logged ratio: 20% (counted above)
  # Remaining ratio: 20/40*(100-40) = 120 = 60
  #
  def get_remaining_ratio(logged_ratio, done_ratio)
    if done_ratio.to_f == 0.0
      100
    else
      logged_ratio.to_f / done_ratio.to_f * (100 - done_ratio.to_f)
    end
  end

  # Number of remaining hours depending on logged hours.
  #
  # Logged hours: 4h
  # Logged ratio: 20% (counted above)
  # Remaining ratio: 20/40*(100-40) = 120 = 60
  # Remaining hours: 4/20*120 = 24
  #
  def get_remaining_hours(logged_hours, estimated_hours, logged_ratio, remaining_ratio)
    if logged_ratio > 0
      remaining_hours = logged_hours.to_f / logged_ratio.to_f * remaining_ratio.to_f
    else
      remaining_hours = estimated_hours.to_f * remaining_ratio.to_f / 100
    end
    remaining_hours += 1 if remaining_hours < 0.5
    remaining_hours
  end

  def get_remaining_hint(logged_ratio, remaining_ratio, done_ratio, logged_hours, remaining_hours, estimated_hours, row = nil)
    hint = ''
    if logged_ratio + remaining_ratio > 100 # Issue is delayed.
      hint << l(:charts_deviation_hint_remaining_over_estimation,  remaining_hours: RedmineCharts::Utils.round(remaining_hours), hours_over_estimation: RedmineCharts::Utils.round(logged_hours.to_f + remaining_hours.to_f - estimated_hours.to_f), over_estimation: (logged_ratio.to_f + remaining_ratio.to_f - 100).round)
    else
      hint << l(:charts_deviation_hint_remaining,  remaining_hours: RedmineCharts::Utils.round(remaining_hours))
    end
    hint << l(:charts_deviation_hint_issue,  estimated_hours: RedmineCharts::Utils.round(estimated_hours), work_done: done_ratio.to_f.round)
    if row
      hint << l(:charts_deviation_hint_label,  issue_id: row.group_id, issue_name: row.subject)
    else
      hint << l(:charts_deviation_hint_project_label)
    end
    hint
  end

  def get_logged_hint(logged_ratio, remaining_ratio, done_ratio, logged_hours, estimated_hours, row = nil)
    hint = ''
    if logged_ratio > 100 and remaining_ratio == 0 # Issue is finished.
      hint << l(:charts_deviation_hint_logged_over_estimation,  logged_hours: RedmineCharts::Utils.round(logged_hours), hours_over_estimation: RedmineCharts::Utils.round(logged_hours.to_f - estimated_hours.to_f), over_estimation: (logged_ratio.to_f - 100).round)
    else
      hint << l(:charts_deviation_hint_logged,  logged_hours: RedmineCharts::Utils.round(logged_hours))
    end
    hint << l(:charts_deviation_hint_issue,  estimated_hours: RedmineCharts::Utils.round(estimated_hours), work_done: done_ratio.to_f.round)
    if row
      hint << l(:charts_deviation_hint_label,  issue_id: row.group_id, issue_name: row.subject)
    else
      hint << l(:charts_deviation_hint_project_label)
    end
    hint
  end
end
