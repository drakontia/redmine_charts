class ChartsTimelineController < ChartsController
  unloadable

  protected

  def get_data
    rows, @range = ChartTimeEntry.get_timeline(@grouping, @conditions, @range)

    sets = {}
    max = 0

    if rows.size > 0
      rows.each do |row|
        group_name = RedmineCharts::GroupingUtils.to_string(row.group_id, @grouping)
        index = @range[:keys].index(row.range_value.to_s)
        if index
          sets[group_name] ||= Array.new(@range[:keys].size, [0, get_hints])
          sets[group_name][index] = [row.logged_hours.to_f, get_hints(row)]
          max = row.logged_hours.to_f if max < row.logged_hours.to_f
        else
          fail row.range_value.to_s
        end
      end
    else
      sets[''] ||= Array.new(@range[:keys].size, [0, get_hints])
    end

    sets = sets.sort.map { |name, values| [name, values] }

    {
      labels: @range[:labels],
      count: @range[:keys].size,
      max: max > 1 ? max : 1,
      sets: sets
    }
  end

  def get_hints(record = nil)
    unless record.nil?
      l(:charts_timeline_hint,  hours: RedmineCharts::Utils.round(record.logged_hours), entries: record.entries.to_i)
    else
      l(:charts_timeline_hint_empty)
    end
  end

  def get_title
    l(:charts_link_timeline)
  end

  def get_help
    l(:charts_timeline_help)
  end

  def get_type
    :line
  end

  def get_x_legend
    l(:charts_timeline_x)
  end

  def get_y_legend
    l(:charts_timeline_y)
  end

  def show_date_condition
    true
  end

  def get_grouping_options
    [:none, RedmineCharts::GroupingUtils.types].flatten
  end

  def get_multiconditions_options
    RedmineCharts::ConditionsUtils.types
  end
end
