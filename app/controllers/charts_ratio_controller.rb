class ChartsRatioController < ChartsController
  unloadable

  protected

  def get_data
    rows = ChartTimeEntry.get_aggregation(@grouping, @conditions)

    bigger_rows = []
    total_hours = 0
    other_value = 0
    other_no = 0

    rows.each do |row|
      total_hours += row.logged_hours.to_f
    end

    rows.each do |row|
      if row.group_id.to_i == 0 or ((other_value + row.logged_hours.to_f) / total_hours) < 0.05
        other_value += row.logged_hours.to_f
        other_no += 1
      else
        bigger_rows << row
      end
    end

    if other_no > 1
      rows = bigger_rows
      other_row = Struct.new(:value_x, :logged_hours, :group_id, :grouping).new
      other_row.logged_hours = other_value
      other_row.group_id = 0
      other_row.grouping = :others
      rows << other_row
    end

    labels = []
    set = []
    error = nil

    if rows.empty?
      error = :charts_error_no_data
    else
      rows.each do |row|
        labels << l(:charts_ratio_label,  label: RedmineCharts::GroupingUtils.to_string(row.group_id, row.grouping.to_sym, l(:charts_ratio_others)))
        hint = l(:charts_ratio_hint,  label: RedmineCharts::GroupingUtils.to_string(row.group_id, row.grouping.to_sym, l(:charts_ratio_others)), hours: RedmineCharts::Utils.round(row.logged_hours), percent: RedmineCharts::Utils.percent(row.logged_hours, total_hours), total_hours: RedmineCharts::Utils.round(total_hours))
        set << [RedmineCharts::Utils.round(row.logged_hours), hint]
      end
    end

    {
      error: error,
      labels: labels,
      count: rows.size,
      max: 0,
      sets: { '' => set }
    }
  end

  def get_title
    l(:charts_link_ratio)
  end

  def get_help
    l(:charts_ratio_help)
  end

  def get_type
    :pie
  end

  def get_grouping_options
    RedmineCharts::GroupingUtils.types
  end

  def get_multiconditions_options
    RedmineCharts::ConditionsUtils.types
  end
end
