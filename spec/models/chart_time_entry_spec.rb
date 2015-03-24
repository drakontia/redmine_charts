require File.dirname(__FILE__) + '/../spec_helper'

describe ChartTimeEntry do

  it 'should aggregation_for_nil_grouping' do
   aggregation = ChartTimeEntry.get_aggregation(nil,  project_ids: 15_041)
   expect(aggregation.size).to eq(3)
   expect(aggregation[0].grouping).to eq('user_id')
   expect(aggregation[0].group_id).to eq(2)
   expect(aggregation[1].group_id).to eq(1)
   expect(aggregation[2].group_id).to eq(3)
   expect(aggregation[0].logged_hours.to_f).to be_within(0.1).of(16.8)
   expect(aggregation[1].logged_hours.to_f).to be_within(0.1).of(14.15)
   expect(aggregation[2].logged_hours.to_f).to be_within(0.1).of(5.1)
   expect(aggregation[0].entries).to eq(6)
   expect(aggregation[1].entries).to eq(4)
   expect(aggregation[2].entries).to eq(1)
 end

  it 'should aggregation_for_user_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(nil,  project_ids: [15_041, 15_043])
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('user_id')
    expect(aggregation[0].group_id).to eq(2)
    expect(aggregation[1].group_id).to eq(1)
    expect(aggregation[2].group_id).to eq(3)
    expect(aggregation[0].logged_hours.to_f).to be_within(0.1).of(16.8)
    expect(aggregation[1].logged_hours.to_f).to be_within(0.1).of(14.15)
    expect(aggregation[2].logged_hours.to_f).to be_within(0.1).of(12.1)
    expect(aggregation[0].entries).to eq(6)
    expect(aggregation[1].entries).to eq(4)
    expect(aggregation[2].entries).to eq(2)
  end

  it 'should aggregation_for_issue_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:issue_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(5)
    expect(aggregation[0].grouping).to eq('issue_id')
    expect(aggregation[0].group_id).to eq(15_044)
    expect(aggregation[1].group_id).to eq(15_045)
    expect(aggregation[2].group_id).to eq(15_043)
    expect(aggregation[3].group_id).to eq(15_041)
    expect(aggregation[4].group_id).to eq('0')
    expect(aggregation[0].estimated_hours.to_f).to be_within(0.1).of(0)
    expect(aggregation[1].estimated_hours.to_f).to be_within(0.1).of(12)
    expect(aggregation[2].estimated_hours.to_f).to be_within(0.1).of(8)
    expect(aggregation[3].estimated_hours.to_f).to be_within(0.1).of(10)
    expect(aggregation[4].estimated_hours.to_f).to be_within(0.1).of(0)
    expect(aggregation[0].subject).to eq('Issue4')
    expect(aggregation[1].subject).to eq('Issue5')
    expect(aggregation[2].subject).to eq('Issue3')
    expect(aggregation[3].subject).to eq('Issue1')
    expect(aggregation[4].subject).to be_nil
    expect(aggregation[0].logged_hours.to_f).to be_within(0.1).of(8.9)
    expect(aggregation[1].logged_hours.to_f).to be_within(0.1).of(8.9)
    expect(aggregation[2].logged_hours.to_f).to be_within(0.1).of(7.6)
    expect(aggregation[3].logged_hours.to_f).to be_within(0.1).of(5.55)
    expect(aggregation[4].logged_hours.to_f).to be_within(0.1).of(5.0)
    expect(aggregation[0].entries).to eq(3)
    expect(aggregation[1].entries).to eq(3)
    expect(aggregation[2].entries).to eq(2)
    expect(aggregation[3].entries).to eq(2)
    expect(aggregation[4].entries).to eq(1)
  end

  it 'should aggregation_for_activity_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:activity_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(2)
    expect(aggregation[0].grouping).to eq('activity_id')
  end

  it 'should aggregation_for_category_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:category_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('category_id')
    expect(aggregation[0].group_id).to eq(15_042)
    expect(aggregation[1].group_id).to eq(15_041)
    expect(aggregation[2].group_id).to eq('0')
    expect(aggregation[0].logged_hours.to_f).to be_within(0.1).of(25.4)
    expect(aggregation[1].logged_hours.to_f).to be_within(0.1).of(5.55)
    expect(aggregation[2].logged_hours.to_f).to be_within(0.1).of(5.1)
    expect(aggregation[0].entries).to eq(8)
    expect(aggregation[1].entries).to eq(2)
    expect(aggregation[2].entries).to eq(1)
  end

  it 'should aggregation_for_priority_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:priority_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('priority_id')
  end

  it 'should aggregation_for_tracker_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:tracker_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('tracker_id')
  end

  it 'should aggregation_for_version_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:fixed_version_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('fixed_version_id')
  end

  it 'should aggregation_for_author_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:author_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(3)
    expect(aggregation[0].grouping).to eq('author_id')
  end

  it 'should aggregation_for_status_grouping' do
    aggregation = ChartTimeEntry.get_aggregation(:status_id,  project_ids: 15_041)
    expect(aggregation.size).to eq(4)
    expect(aggregation[0].grouping).to eq('status_id')
  end

  it 'should timeline' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(4)
    expect(timeline[0].range_type).to eq('weeks')
    expect(timeline[0].range_value).to eq(2_010_004)
    expect(timeline[3].range_value).to eq(2_010_010)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_days_full_range' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :days, limit: 100, offset: 0)
    expect(timeline.size).to eq(7)
    expect(timeline[0].range_type).to eq('days')
    expect(timeline[0].range_value).to eq(2_010_031)
    expect(timeline[0].logged_hours).to be_within(1).of(4.55)
    expect(timeline[0].entries).to eq(1)
    expect(timeline[1].range_value).to eq(2_010_032)
    expect(timeline[1].logged_hours).to be_within(1).of(1.3)
    expect(timeline[1].entries).to eq(1)
    expect(timeline[2].range_value).to eq(2_010_062)
    expect(timeline[2].logged_hours).to be_within(1).of(7.6)
    expect(timeline[2].entries).to eq(2)
    expect(timeline[3].range_value).to eq(2_010_064)
    expect(timeline[3].logged_hours).to be_within(1).of(2.3)
    expect(timeline[3].entries).to eq(1)
    expect(timeline[4].range_value).to eq(2_010_065)
    expect(timeline[4].logged_hours).to be_within(1).of(6.6)
    expect(timeline[4].entries).to eq(2)
    expect(timeline[5].range_value).to eq(2_010_068)
    expect(timeline[5].logged_hours).to be_within(1).of(6.6)
    expect(timeline[5].entries).to eq(2)
    expect(timeline[6].range_value).to eq(2_010_069)
    expect(timeline[6].logged_hours).to be_within(1).of(7.3)
    expect(timeline[6].entries).to eq(2)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_weeks_full_range' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :weeks, limit: 100, offset: 0)
    expect(timeline.size).to eq(4)
    expect(timeline[0].range_type).to eq('weeks')
    expect(timeline[0].range_value).to eq(2_010_004)
    expect(timeline[0].logged_hours).to be_within(1).of(4.55)
    expect(timeline[0].entries).to eq(1)
    expect(timeline[1].range_value).to eq(2_010_005)
    expect(timeline[1].logged_hours).to be_within(1).of(1.3)
    expect(timeline[1].entries).to eq(1)
    expect(timeline[2].range_value).to eq(2_010_009)
    expect(timeline[2].logged_hours).to be_within(1).of(16.5)
    expect(timeline[2].entries).to eq(5)
    expect(timeline[3].range_value).to eq(2_010_010)
    expect(timeline[3].logged_hours).to be_within(1).of(14)
    expect(timeline[3].entries).to eq(4)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_months_full_range' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :months, limit: 100, offset: 0)
    expect(timeline.size).to eq(3)
    expect(timeline[0].range_type).to eq('months')
    expect(timeline[0].range_value).to eq(2_010_001)
    expect(timeline[0].logged_hours).to be_within(1).of(4.55)
    expect(timeline[0].entries).to eq(1)
    expect(timeline[1].range_value).to eq(2_010_002)
    expect(timeline[1].logged_hours).to be_within(1).of(1.3)
    expect(timeline[1].entries).to eq(1)
    expect(timeline[2].range_value).to eq(2_010_003)
    expect(timeline[2].logged_hours).to be_within(1).of(30.5)
    expect(timeline[2].entries).to eq(9)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_days_restricted' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :days, limit: 10, offset: 0)
    expect(timeline.size).to eq(5)
    expect(timeline[0].range_type).to eq('days')
    expect(timeline[0].range_value).to eq(2_010_062)
    expect(timeline[4].range_value).to eq(2_010_069)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_weeks_restricted' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :weeks, limit: 5, offset: 1)
    expect(timeline.size).to eq(2)
    expect(timeline[0].range_type).to eq('weeks')
    expect(timeline[0].range_value).to eq(2_010_005)
    expect(timeline[1].range_value).to eq(2_010_009)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_months_restricted' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041 }, range: :months, limit: 0, offset: 1)
    expect(timeline.size).to eq(1)
    expect(timeline[0].range_type).to eq('months')
    expect(timeline[0].range_value).to eq(2_010_002)
    expect(timeline[0].group_id.to_i).to eq(0)
    expect(timeline[0].grouping).to eq('')
  end

  it 'should timeline_groping_users' do
    timeline, range = ChartTimeEntry.get_timeline(:user_id, { project_ids: 15_041 }, range: :months, limit: 10, offset: 0)
    expect(timeline.size).to eq(5)
    expect(timeline[0].range_type).to eq('months')
    expect(timeline[0].grouping).to eq('user_id')
    expect(timeline[0].range_value).to eq(2_010_001)
    expect(timeline[0].group_id.to_i).to eq(1)
    expect(timeline[0].logged_hours).to be_within(1).of(4.25)
    expect(timeline[0].entries).to eq(1)
    expect(timeline[1].range_value).to eq(2_010_002)
    expect(timeline[1].group_id.to_i).to eq(2)
    expect(timeline[1].logged_hours).to be_within(1).of(1.3)
    expect(timeline[1].entries).to eq(1)
    expect(timeline[2].range_value).to eq(2_010_003)
    expect(timeline[2].group_id.to_i).to eq(1)
    expect(timeline[2].logged_hours).to be_within(1).of(9.9)
    expect(timeline[2].entries).to eq(3)
    expect(timeline[3].range_value).to eq(2_010_003)
    expect(timeline[3].group_id.to_i).to eq(2)
    expect(timeline[3].logged_hours).to be_within(1).of(15.5)
    expect(timeline[3].entries).to eq(5)
    expect(timeline[4].range_value).to eq(2_010_003)
    expect(timeline[4].group_id.to_i).to eq(3)
    expect(timeline[4].logged_hours).to be_within(1).of(5.1)
    expect(timeline[4].entries).to eq(1)
  end

  it 'should timeline_groping_issues' do
    timeline, range = ChartTimeEntry.get_timeline(:issue_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(6)
  end

  it 'should timeline_groping_activities' do
    timeline, range = ChartTimeEntry.get_timeline(:activity_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(6)
  end

  it 'should timeline_groping_categories' do
    timeline, range = ChartTimeEntry.get_timeline(:category_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(5)
  end

  it 'should timeline_groping_trackers' do
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(5)
  end

  it 'should timeline_groping_versions' do
    timeline, range = ChartTimeEntry.get_timeline(:fixed_version_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(6)
  end

  it 'should timeline_groping_priorities' do
    timeline, range = ChartTimeEntry.get_timeline(:priority_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(6)
  end

  it 'should timeline_groping_authors' do
    timeline, range = ChartTimeEntry.get_timeline(:author_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(6)
  end

  it 'should timeline_groping_statuses' do
    timeline, range = ChartTimeEntry.get_timeline(:status_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(5)
  end

  it 'should timeline_groping_projects' do
    timeline, range = ChartTimeEntry.get_timeline(:project_id, { project_ids: 15_041 }, nil)
    expect(timeline.size).to eq(4)
  end

  it 'should timeline_groping_and_conditions' do
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, { project_ids: 15_041, category_ids: 15_042 }, nil)
    expect(timeline.size).to eq(2)
    expect(timeline[0].range_type).to eq('weeks')
    expect(timeline[0].grouping).to eq('tracker_id')
    expect(timeline[0].range_value).to eq(2_010_009)
    expect(timeline[0].group_id.to_i).to eq(2)
    expect(timeline[0].logged_hours).to be_within(1).of(16.5)
    expect(timeline[0].entries).to eq(5)
    expect(timeline[1].range_value).to eq(2_010_010)
    expect(timeline[1].group_id.to_i).to eq(1)
    expect(timeline[1].logged_hours).to be_within(1).of(8.9)
    expect(timeline[1].entries).to eq(3)
  end

  it 'should timeline_condition_user_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, user_ids: 2 }, nil)
    expect(timeline.size).to eq(3)
  end

  it 'should timeline_condition_issue_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, issue_id: 15_041 }, nil)
    expect(timeline.size).to eq(4)
  end

  it 'should timeline_condition_activity_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, activity_ids: 9 }, nil)
    expect(timeline.size).to eq(3)
  end

  it 'should timeline_condition_category_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, category_ids: 15_042 }, nil)
    expect(timeline.size).to eq(2)
  end

  it 'should timeline_condition_tracker_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, tracker_ids: 1 }, nil)
    expect(timeline.size).to eq(3)
  end

  it 'should timeline_condition_fixed_version_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, fixed_version_id: 15_042 }, nil)
    expect(timeline.size).to eq(4)
  end

  it 'should timeline_condition_priority_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, priority_ids: 5 }, nil)
    expect(timeline.size).to eq(2)
  end

  it 'should timeline_condition_author_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, author_ids: 1 }, nil)
    expect(timeline.size).to eq(4)
  end

  it 'should timeline_condition_status_ids' do
    timeline, range = ChartTimeEntry.get_timeline(nil, { project_ids: 15_041, status_ids: 1 }, nil)
    expect(timeline.size).to eq(1)
  end

  it 'should aggregation_for_issue' do
    aggregation = ChartTimeEntry.get_aggregation_for_issue({ project_ids: 15_041 }, { range: :weeks, limit: 10, offset: 0 })
    expect(aggregation.size).to eq(5)
    expect(aggregation[0]).to be_within(1).of(5.1)
    expect(aggregation[15_043]).to be_within(1).of(7.6)
    expect(aggregation[15_044]).to be_within(1).of(8.9)
    expect(aggregation[15_045]).to be_within(1).of(8.9)
    expect(aggregation[15_041]).to be_within(1).of(5.5)
  end

end
