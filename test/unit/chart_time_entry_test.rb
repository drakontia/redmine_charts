require File.dirname(__FILE__) + '/../test_helper'

class ChartTimeEntryTest < ActiveSupport::TestCase
  def test_aggregation_for_nil_grouping
    aggregation = ChartTimeEntry.get_aggregation(nil,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'user_id', aggregation[0].grouping
    assert_equal '2', aggregation[0].group_id
    assert_equal '1', aggregation[1].group_id
    assert_equal '3', aggregation[2].group_id
    assert_in_delta 16.8, aggregation[0].logged_hours.to_f, 0.1
    assert_in_delta 14.15, aggregation[1].logged_hours.to_f, 0.1
    assert_in_delta 5.1, aggregation[2].logged_hours.to_f, 0.1
    assert_equal 6, aggregation[0].entries
    assert_equal 4, aggregation[1].entries
    assert_equal 1, aggregation[2].entries
 end

  def test_aggregation_for_user_grouping
    aggregation = ChartTimeEntry.get_aggregation(nil,  project_ids: [15_041, 15_043])
    assert_equal 3, aggregation.size
    assert_equal 'user_id', aggregation[0].grouping
    assert_equal '2', aggregation[0].group_id
    assert_equal '1', aggregation[1].group_id
    assert_equal '3', aggregation[2].group_id
    assert_in_delta 16.8, aggregation[0].logged_hours.to_f, 0.1
    assert_in_delta 14.15, aggregation[1].logged_hours.to_f, 0.1
    assert_in_delta 12.1, aggregation[2].logged_hours.to_f, 0.1
    assert_equal 6, aggregation[0].entries
    assert_equal 4, aggregation[1].entries
    assert_equal 2, aggregation[2].entries
  end

  def test_aggregation_for_issue_grouping
    aggregation = ChartTimeEntry.get_aggregation(:issue_id,  project_ids: 15_041)
    assert_equal 5, aggregation.size
    assert_equal 'issue_id', aggregation[0].grouping
    assert_equal '15044', aggregation[0].group_id
    assert_equal '15045', aggregation[1].group_id
    assert_equal '15043', aggregation[2].group_id
    assert_equal '15041', aggregation[3].group_id
    assert_equal '0', aggregation[4].group_id
    assert_in_delta 0, aggregation[0].estimated_hours.to_f, 0.1
    assert_in_delta 12, aggregation[1].estimated_hours.to_f, 0.1
    assert_in_delta 8, aggregation[2].estimated_hours.to_f, 0.1
    assert_in_delta 10, aggregation[3].estimated_hours.to_f, 0.1
    assert_in_delta 0, aggregation[4].estimated_hours.to_f, 0.1
    assert_equal 'Issue4', aggregation[0].subject
    assert_equal 'Issue5', aggregation[1].subject
    assert_equal 'Issue3', aggregation[2].subject
    assert_equal 'Issue1', aggregation[3].subject
    assert_nil aggregation[4].subject
    assert_in_delta 8.9, aggregation[0].logged_hours.to_f, 0.1
    assert_in_delta 8.9, aggregation[1].logged_hours.to_f, 0.1
    assert_in_delta 7.6, aggregation[2].logged_hours.to_f, 0.1
    assert_in_delta 5.55, aggregation[3].logged_hours.to_f, 0.1
    assert_in_delta 5.0, aggregation[4].logged_hours.to_f, 0.1
    assert_equal 3, aggregation[0].entries
    assert_equal 3, aggregation[1].entries
    assert_equal 2, aggregation[2].entries
    assert_equal 2, aggregation[3].entries
    assert_equal 1, aggregation[4].entries
  end

  def test_aggregation_for_activity_grouping
    aggregation = ChartTimeEntry.get_aggregation(:activity_id,  project_ids: 15_041)
    assert_equal 2, aggregation.size
    assert_equal 'activity_id', aggregation[0].grouping
  end

  def test_aggregation_for_category_grouping
    aggregation = ChartTimeEntry.get_aggregation(:category_id,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'category_id', aggregation[0].grouping
    assert_equal '15042', aggregation[0].group_id
    assert_equal '15041', aggregation[1].group_id
    assert_equal '0', aggregation[2].group_id
    assert_in_delta 25.4, aggregation[0].logged_hours.to_f, 0.1
    assert_in_delta 5.55, aggregation[1].logged_hours.to_f, 0.1
    assert_in_delta 5.1, aggregation[2].logged_hours.to_f, 0.1
    assert_equal 8, aggregation[0].entries
    assert_equal 2, aggregation[1].entries
    assert_equal 1, aggregation[2].entries
  end

  def test_aggregation_for_priority_grouping
    aggregation = ChartTimeEntry.get_aggregation(:priority_id,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'priority_id', aggregation[0].grouping
  end

  def test_aggregation_for_tracker_grouping
    aggregation = ChartTimeEntry.get_aggregation(:tracker_id,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'tracker_id', aggregation[0].grouping
  end

  def test_aggregation_for_version_grouping
    aggregation = ChartTimeEntry.get_aggregation(:fixed_version_id,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'fixed_version_id', aggregation[0].grouping
  end

  def test_aggregation_for_author_grouping
    aggregation = ChartTimeEntry.get_aggregation(:author_id,  project_ids: 15_041)
    assert_equal 3, aggregation.size
    assert_equal 'author_id', aggregation[0].grouping
  end

  def test_aggregation_for_status_grouping
    aggregation = ChartTimeEntry.get_aggregation(:status_id,  project_ids: 15_041)
    assert_equal 4, aggregation.size
    assert_equal 'status_id', aggregation[0].grouping
  end

  def test_timeline
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, nil)
    assert_equal 4, timeline.size
    assert_equal 'weeks', timeline[0].range_type
    assert_equal '2010004', timeline[0].range_value
    assert_equal '2010010', timeline[3].range_value
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_days_full_range
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :days, limit: 100, offset: 0)
    assert_equal 7, timeline.size
    assert_equal 'days', timeline[0].range_type
    assert_equal '2010031', timeline[0].range_value
    assert_in_delta 4.55, timeline[0].logged_hours, 1
    assert_equal 1, timeline[0].entries
    assert_equal '2010032', timeline[1].range_value
    assert_in_delta 1.3, timeline[1].logged_hours, 1
    assert_equal 1, timeline[1].entries
    assert_equal '2010062', timeline[2].range_value
    assert_in_delta 7.6, timeline[2].logged_hours, 1
    assert_equal 2, timeline[2].entries
    assert_equal '2010064', timeline[3].range_value
    assert_in_delta 2.3, timeline[3].logged_hours, 1
    assert_equal 1, timeline[3].entries
    assert_equal '2010065', timeline[4].range_value
    assert_in_delta 6.6, timeline[4].logged_hours, 1
    assert_equal 2, timeline[4].entries
    assert_equal '2010068', timeline[5].range_value
    assert_in_delta 6.6, timeline[5].logged_hours, 1
    assert_equal 2, timeline[5].entries
    assert_equal '2010069', timeline[6].range_value
    assert_in_delta 7.3, timeline[6].logged_hours, 1
    assert_equal 2, timeline[6].entries
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_weeks_full_range
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :weeks, limit: 100, offset: 0)
    assert_equal 4, timeline.size
    assert_equal 'weeks', timeline[0].range_type
    assert_equal '2010004', timeline[0].range_value
    assert_in_delta 4.55, timeline[0].logged_hours, 1
    assert_equal 1, timeline[0].entries
    assert_equal '2010005', timeline[1].range_value
    assert_in_delta 1.3, timeline[1].logged_hours, 1
    assert_equal 1, timeline[1].entries
    assert_equal '2010009', timeline[2].range_value
    assert_in_delta 16.5, timeline[2].logged_hours, 1
    assert_equal 5, timeline[2].entries
    assert_equal '2010010', timeline[3].range_value
    assert_in_delta 14, timeline[3].logged_hours, 1
    assert_equal 4, timeline[3].entries
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_months_full_range
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :months, limit: 100, offset: 0)
    assert_equal 3, timeline.size
    assert_equal 'months', timeline[0].range_type
    assert_equal '2010001', timeline[0].range_value
    assert_in_delta 4.55, timeline[0].logged_hours, 1
    assert_equal 1, timeline[0].entries
    assert_equal '2010002', timeline[1].range_value
    assert_in_delta 1.3, timeline[1].logged_hours, 1
    assert_equal 1, timeline[1].entries
    assert_equal '2010003', timeline[2].range_value
    assert_in_delta 30.5, timeline[2].logged_hours, 1
    assert_equal 9, timeline[2].entries
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_days_restricted
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :days, limit: 10, offset: 0)
    assert_equal 5, timeline.size
    assert_equal 'days', timeline[0].range_type
    assert_equal '2010062', timeline[0].range_value
    assert_equal '2010069', timeline[4].range_value
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_weeks_restricted
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :weeks, limit: 5, offset: 1)
    assert_equal 2, timeline.size
    assert_equal 'weeks', timeline[0].range_type
    assert_equal '2010005', timeline[0].range_value
    assert_equal '2010009', timeline[1].range_value
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_months_restricted
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :months, limit: 0, offset: 1)
    assert_equal 1, timeline.size
    assert_equal 'months', timeline[0].range_type
    assert_equal '2010002', timeline[0].range_value
    assert_equal 0, timeline[0].group_id.to_i
    assert_equal '', timeline[0].grouping
  end

  def test_timeline_groping_users
    timeline, range = ChartTimeEntry.get_timeline(:user_id, { project_ids: 15_041 }, range: :months, limit: 10, offset: 0)
    assert_equal 5, timeline.size
    assert_equal 'months', timeline[0].range_type
    assert_equal 'user_id', timeline[0].grouping
    assert_equal '2010001', timeline[0].range_value
    assert_equal 1, timeline[0].group_id.to_i
    assert_in_delta 4.25, timeline[0].logged_hours, 1
    assert_equal 1, timeline[0].entries
    assert_equal '2010002', timeline[1].range_value
    assert_equal 2, timeline[1].group_id.to_i
    assert_in_delta 1.3, timeline[1].logged_hours, 1
    assert_equal 1, timeline[1].entries
    assert_equal '2010003', timeline[2].range_value
    assert_equal 1, timeline[2].group_id.to_i
    assert_in_delta 9.9, timeline[2].logged_hours, 1
    assert_equal 3, timeline[2].entries
    assert_equal '2010003', timeline[3].range_value
    assert_equal 2, timeline[3].group_id.to_i
    assert_in_delta 15.5, timeline[3].logged_hours, 1
    assert_equal 5, timeline[3].entries
    assert_equal '2010003', timeline[4].range_value
    assert_equal 3, timeline[4].group_id.to_i
    assert_in_delta 5.1, timeline[4].logged_hours, 1
    assert_equal 1, timeline[4].entries
  end

  def test_timeline_groping_issues
    timeline, range = ChartTimeEntry.get_timeline(:issue_id, { project_ids: 15_041 }, nil)
    assert_equal 6, timeline.size
  end

  def test_timeline_groping_activities
    timeline, range = ChartTimeEntry.get_timeline(:activity_id, { project_ids: 15_041 }, nil)
    assert_equal 6, timeline.size
  end

  def test_timeline_groping_categories
    timeline, range = ChartTimeEntry.get_timeline(:category_id, { project_ids: 15_041 }, nil)
    assert_equal 5, timeline.size
  end

  def test_timeline_groping_trackers
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, { project_ids: 15_041 }, nil)
    assert_equal 5, timeline.size
  end

  def test_timeline_groping_versions
    timeline, range = ChartTimeEntry.get_timeline(:fixed_version_id, { project_ids: 15_041 }, nil)
    assert_equal 6, timeline.size
  end

  def test_timeline_groping_priorities
    timeline, range = ChartTimeEntry.get_timeline(:priority_id, { project_ids: 15_041 }, nil)
    assert_equal 6, timeline.size
  end

  def test_timeline_groping_authors
    timeline, range = ChartTimeEntry.get_timeline(:author_id, { project_ids: 15_041 }, nil)
    assert_equal 6, timeline.size
  end

  def test_timeline_groping_statuses
    timeline, range = ChartTimeEntry.get_timeline(:status_id, { project_ids: 15_041 }, nil)
    assert_equal 5, timeline.size
  end

  def test_timeline_groping_projects
    timeline, range = ChartTimeEntry.get_timeline(:project_id, { project_ids: 15_041 }, nil)
    assert_equal 4, timeline.size
  end

  def test_timeline_groping_and_conditions
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, { project_ids: 15_041, category_ids: 15_042 }, nil)
    assert_equal 2, timeline.size
    assert_equal 'weeks', timeline[0].range_type
    assert_equal 'tracker_id', timeline[0].grouping
    assert_equal '2010009', timeline[0].range_value
    assert_equal 2, timeline[0].group_id.to_i
    assert_in_delta 16.5, timeline[0].logged_hours, 1
    assert_equal 5, timeline[0].entries
    assert_equal '2010010', timeline[1].range_value
    assert_equal 1, timeline[1].group_id.to_i
    assert_in_delta 8.9, timeline[1].logged_hours, 1
    assert_equal 3, timeline[1].entries
  end

  def test_timeline_condition_user_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, user_ids: 2 }, nil)
    assert_equal 3, timeline.size
  end

  def test_timeline_condition_issue_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, issue_id: 15_041 }, nil)
    assert_equal 4, timeline.size
  end

  def test_timeline_condition_activity_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, activity_ids: 9 }, nil)
    assert_equal 3, timeline.size
  end

  def test_timeline_condition_category_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, category_ids: 15_042 }, nil)
    assert_equal 2, timeline.size
  end

  def test_timeline_condition_tracker_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, tracker_ids: 1 }, nil)
    assert_equal 3, timeline.size
  end

  def test_timeline_condition_fixed_version_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, fixed_version_id: 15_042 }, nil)
    assert_equal 4, timeline.size
  end

  def test_timeline_condition_priority_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, priority_ids: 5 }, nil)
    assert_equal 2, timeline.size
  end

  def test_timeline_condition_author_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, author_ids: 1 }, nil)
    assert_equal 4, timeline.size
  end

  def test_timeline_condition_status_ids
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, status_ids: 1 }, nil)
    assert_equal 1, timeline.size
  end

  def test_aggregation_for_issue
    aggregation = ChartTimeEntry.get_aggregation_for_issue({ project_ids: 15_041 }, { range: :weeks, limit: 10, offset: 0 })
    assert_equal 5, aggregation.size
    assert_in_delta 5.1, aggregation[0], 1
    assert_in_delta 7.6, aggregation[15_043], 1
    assert_in_delta 8.9, aggregation[15_044], 1
    assert_in_delta 8.9, aggregation[15_045], 1
    assert_in_delta 5.5, aggregation[15_041], 1
  end
end
