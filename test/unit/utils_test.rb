require File.dirname(__FILE__) + '/../test_helper'

class ConditionsUtilsTest < ActiveSupport::TestCase
  def test_if_return_default_controller
    assert_equal 'charts_burndown', RedmineCharts::Utils.default_controller
  end

  def test_if_return_controllers_for_permissions
    assert_equal({ charts_burndown: :index, charts_burndown2: :index, charts_ratio: :index, charts_timeline: :index, charts_deviation: :index, charts_issue: :index }, RedmineCharts::Utils.controllers_for_permissions)
  end

  def test_if_return_controllers_for_routing
    result = []
    RedmineCharts::Utils.controllers_for_routing do |k, v|
      result << [k, v]
    end
    assert_equal [%w(burndown charts_burndown), %w(burndown2 charts_burndown2), %w(ratio charts_ratio), %w(timeline charts_timeline), %w(deviation charts_deviation), %w(issue charts_issue)], result
  end

  def test_if_return_colors
    assert_equal ['#80C31C', '#FF7900', '#DFC329', '#00477F', '#d01f3c', '#356aa0', '#C79810', '#4C88BE', '#5E4725', '#6363AC'], RedmineCharts::Utils.colors
    assert_equal '#DFC329', RedmineCharts::Utils.color(2)
  end

  def test_if_can_round
    assert_equal 0.0, RedmineCharts::Utils.round(0)
    assert_equal 3.0, RedmineCharts::Utils.round(3)
    assert_equal 3.1, RedmineCharts::Utils.round(3.1)
    assert_equal 3.2, RedmineCharts::Utils.round(3.11)
    assert_equal 3.2, RedmineCharts::Utils.round(3.191111)
  end

  def test_if_can_get_percent
    assert_equal 0, RedmineCharts::Utils.percent(1, 0)
    assert_equal 30, RedmineCharts::Utils.percent(3, 10)
    assert_equal 27, RedmineCharts::Utils.percent(3, 11)
  end
end
