require File.dirname(__FILE__) + '/../test_helper'

class ChartDoneRatioTest < ActiveSupport::TestCase
  def test_aggregation
    aggregation = ChartDoneRatio.get_aggregation_for_issue(project_ids: [15_041])
    assert_equal 100, aggregation[15_041]
    assert_equal 60, aggregation[15_043]
    assert_equal 100, aggregation[15_044]
    assert_equal 60, aggregation[15_045]
  end

  def test_timeline
    Time.set_current_date = Time.mktime(2010, 4, 1)
    timeline = ChartDoneRatio.get_timeline_for_issue({ project_ids: 15_041 }, { range: :weeks, limit: 11, offset: 0 })
    assert_equal 4, timeline.size
    assert_equal 11, timeline[15_041].size
    assert_equal 11, timeline[15_043].size
    assert_equal 11, timeline[15_044].size
    assert_equal 11, timeline[15_045].size
    assert_equal 0, timeline[15_041][0]
    assert_equal 30, timeline[15_041][1]
    assert_equal 100, timeline[15_041][2]
    assert_equal 100, timeline[15_041][9]
  end
end
