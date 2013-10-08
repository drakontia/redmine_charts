require File.dirname(__FILE__) + '/../spec_helper'

describe ChartTimeEntry do

  it "should aggregation_for_nil_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(nil, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'user_id'
    aggregation[0].group_id.should == 2
    aggregation[1].group_id.should == 1
    aggregation[2].group_id.should == 3
    aggregation[0].logged_hours.to_f.should be_within(0.1).of(16.8)
    aggregation[1].logged_hours.to_f.should be_within(0.1).of(14.15)
    aggregation[2].logged_hours.to_f.should be_within(0.1).of(5.1)
    aggregation[0].entries.should == 6
    aggregation[1].entries.should == 4
    aggregation[2].entries.should == 1
 end

  it "should aggregation_for_user_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(nil, { :project_ids => [15041, 15043]})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'user_id'
    aggregation[0].group_id.should == 2
    aggregation[1].group_id.should == 1
    aggregation[2].group_id.should == 3
    aggregation[0].logged_hours.to_f.should be_within(0.1).of(16.8)
    aggregation[1].logged_hours.to_f.should be_within(0.1).of(14.15)
    aggregation[2].logged_hours.to_f.should be_within(0.1).of(12.1)
    aggregation[0].entries.should == 6
    aggregation[1].entries.should == 4
    aggregation[2].entries.should == 2
  end

  it "should aggregation_for_issue_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:issue_id, { :project_ids => 15041})
    aggregation.size.should == 5
    aggregation[0].grouping.should == 'issue_id'
    aggregation[0].group_id.should == 15044
    aggregation[1].group_id.should == 15045
    aggregation[2].group_id.should == 15043
    aggregation[3].group_id.should == 15041
    aggregation[4].group_id.should == '0'
    aggregation[0].estimated_hours.to_f.should be_within(0.1).of(0)
    aggregation[1].estimated_hours.to_f.should be_within(0.1).of(12)
    aggregation[2].estimated_hours.to_f.should be_within(0.1).of(8)
    aggregation[3].estimated_hours.to_f.should be_within(0.1).of(10)
    aggregation[4].estimated_hours.to_f.should be_within(0.1).of(0)
    aggregation[0].subject.should == "Issue4"
    aggregation[1].subject.should == "Issue5"
    aggregation[2].subject.should == "Issue3"
    aggregation[3].subject.should == "Issue1"
    aggregation[4].subject.should be_nil
    aggregation[0].logged_hours.to_f.should be_within(0.1).of(8.9)
    aggregation[1].logged_hours.to_f.should be_within(0.1).of(8.9)
    aggregation[2].logged_hours.to_f.should be_within(0.1).of(7.6)
    aggregation[3].logged_hours.to_f.should be_within(0.1).of(5.55)
    aggregation[4].logged_hours.to_f.should be_within(0.1).of(5.0)
    aggregation[0].entries.should == 3
    aggregation[1].entries.should == 3
    aggregation[2].entries.should == 2
    aggregation[3].entries.should == 2
    aggregation[4].entries.should == 1
  end

  it "should aggregation_for_activity_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:activity_id, { :project_ids => 15041})
    aggregation.size.should == 2
    aggregation[0].grouping.should == 'activity_id'
  end

  it "should aggregation_for_category_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:category_id, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'category_id'
    aggregation[0].group_id.should == 15042
    aggregation[1].group_id.should == 15041
    aggregation[2].group_id.should == '0'
    aggregation[0].logged_hours.to_f.should be_within(0.1).of(25.4)
    aggregation[1].logged_hours.to_f.should be_within(0.1).of(5.55)
    aggregation[2].logged_hours.to_f.should be_within(0.1).of(5.1)
    aggregation[0].entries.should == 8
    aggregation[1].entries.should == 2
    aggregation[2].entries.should == 1
  end

  it "should aggregation_for_priority_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:priority_id, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'priority_id'
  end

  it "should aggregation_for_tracker_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:tracker_id, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'tracker_id'
  end

  it "should aggregation_for_version_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:fixed_version_id, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'fixed_version_id'
  end

  it "should aggregation_for_author_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:author_id, { :project_ids => 15041})
    aggregation.size.should == 3
    aggregation[0].grouping.should == 'author_id'
  end

  it "should aggregation_for_status_grouping" do
    aggregation = ChartTimeEntry.get_aggregation(:status_id, { :project_ids => 15041})
    aggregation.size.should == 4
    aggregation[0].grouping.should == 'status_id'
  end

  it "should timeline" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, nil)
    timeline.size.should == 4
    timeline[0].range_type.should == 'weeks'
    timeline[0].range_value.should == 2010004
    timeline[3].range_value.should == 2010010
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_days_full_range" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :days, :limit => 100, :offset => 0})
    timeline.size.should == 7
    timeline[0].range_type.should == 'days'
    timeline[0].range_value.should == 2010031
    timeline[0].logged_hours.should be_within(1).of(4.55)
    timeline[0].entries.should == 1
    timeline[1].range_value.should == 2010032
    timeline[1].logged_hours.should be_within(1).of(1.3)
    timeline[1].entries.should == 1
    timeline[2].range_value.should == 2010062
    timeline[2].logged_hours.should be_within(1).of(7.6)
    timeline[2].entries.should == 2
    timeline[3].range_value.should == 2010064
    timeline[3].logged_hours.should be_within(1).of(2.3)
    timeline[3].entries.should == 1
    timeline[4].range_value.should == 2010065
    timeline[4].logged_hours.should be_within(1).of(6.6)
    timeline[4].entries.should == 2
    timeline[5].range_value.should == 2010068
    timeline[5].logged_hours.should be_within(1).of(6.6)
    timeline[5].entries.should == 2
    timeline[6].range_value.should == 2010069
    timeline[6].logged_hours.should be_within(1).of(7.3)
    timeline[6].entries.should == 2
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_weeks_full_range" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :weeks, :limit => 100, :offset => 0})
    timeline.size.should == 4
    timeline[0].range_type.should == 'weeks'
    timeline[0].range_value.should == 2010004
    timeline[0].logged_hours.should be_within(1).of(4.55)
    timeline[0].entries.should == 1
    timeline[1].range_value.should == 2010005
    timeline[1].logged_hours.should be_within(1).of(1.3)
    timeline[1].entries.should == 1
    timeline[2].range_value.should == 2010009
    timeline[2].logged_hours.should be_within(1).of(16.5)
    timeline[2].entries.should == 5
    timeline[3].range_value.should == 2010010
    timeline[3].logged_hours.should be_within(1).of(14)
    timeline[3].entries.should == 4
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_months_full_range" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :months, :limit => 100, :offset => 0})
    timeline.size.should == 3
    timeline[0].range_type.should == 'months'
    timeline[0].range_value.should == 2010001
    timeline[0].logged_hours.should be_within(1).of(4.55)
    timeline[0].entries.should == 1
    timeline[1].range_value.should == 2010002
    timeline[1].logged_hours.should be_within(1).of(1.3)
    timeline[1].entries.should == 1
    timeline[2].range_value.should == 2010003
    timeline[2].logged_hours.should be_within(1).of(30.5)
    timeline[2].entries.should == 9
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_days_restricted" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :days, :limit => 10, :offset => 0})
    timeline.size.should == 5
    timeline[0].range_type.should == 'days'
    timeline[0].range_value.should == 2010062
    timeline[4].range_value.should == 2010069
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_weeks_restricted" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :weeks, :limit => 5, :offset => 1})
    timeline.size.should == 2
    timeline[0].range_type.should == 'weeks'
    timeline[0].range_value.should == 2010005
    timeline[1].range_value.should == 2010009
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_months_restricted" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041}, {:range => :months, :limit => 0, :offset => 1})
    timeline.size.should == 1
    timeline[0].range_type.should == 'months'
    timeline[0].range_value.should == 2010002
    timeline[0].group_id.to_i.should == 0
    timeline[0].grouping.should == ''
  end

  it "should timeline_groping_users" do
    timeline, range = ChartTimeEntry.get_timeline(:user_id, {:project_ids => 15041}, {:range => :months, :limit => 10, :offset => 0})
    timeline.size.should == 5
    timeline[0].range_type.should == 'months'
    timeline[0].grouping.should == 'user_id'
    timeline[0].range_value.should == 2010001
    timeline[0].group_id.to_i.should == 1
    timeline[0].logged_hours.should be_within(1).of(4.25)
    timeline[0].entries.should == 1
    timeline[1].range_value.should == 2010002
    timeline[1].group_id.to_i.should == 2
    timeline[1].logged_hours.should be_within(1).of(1.3)
    timeline[1].entries.should == 1
    timeline[2].range_value.should == 2010003
    timeline[2].group_id.to_i.should == 1
    timeline[2].logged_hours.should be_within(1).of(9.9)
    timeline[2].entries.should == 3
    timeline[3].range_value.should == 2010003
    timeline[3].group_id.to_i.should == 2
    timeline[3].logged_hours.should be_within(1).of(15.5)
    timeline[3].entries.should == 5
    timeline[4].range_value.should == 2010003
    timeline[4].group_id.to_i.should == 3
    timeline[4].logged_hours.should be_within(1).of(5.1)
    timeline[4].entries.should == 1
  end

  it "should timeline_groping_issues" do
    timeline, range = ChartTimeEntry.get_timeline(:issue_id, {:project_ids => 15041}, nil)
    timeline.size.should == 6
  end

  it "should timeline_groping_activities" do
    timeline, range = ChartTimeEntry.get_timeline(:activity_id, {:project_ids => 15041}, nil)
    timeline.size.should == 6
  end

  it "should timeline_groping_categories" do
    timeline, range = ChartTimeEntry.get_timeline(:category_id, {:project_ids => 15041}, nil)
    timeline.size.should == 5
  end

  it "should timeline_groping_trackers" do
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, {:project_ids => 15041}, nil)
    timeline.size.should == 5
  end

  it "should timeline_groping_versions" do
    timeline, range = ChartTimeEntry.get_timeline(:fixed_version_id, {:project_ids => 15041}, nil)
    timeline.size.should == 6
  end

  it "should timeline_groping_priorities" do
    timeline, range = ChartTimeEntry.get_timeline(:priority_id, {:project_ids => 15041}, nil)
    timeline.size.should == 6
  end

  it "should timeline_groping_authors" do
    timeline, range = ChartTimeEntry.get_timeline(:author_id, {:project_ids => 15041}, nil)
    timeline.size.should == 6
  end

  it "should timeline_groping_statuses" do
    timeline, range = ChartTimeEntry.get_timeline(:status_id, {:project_ids => 15041}, nil)
    timeline.size.should == 5
  end

  it "should timeline_groping_projects" do
    timeline, range = ChartTimeEntry.get_timeline(:project_id, {:project_ids => 15041}, nil)
    timeline.size.should == 4
  end

  it "should timeline_groping_and_conditions" do
    timeline, range = ChartTimeEntry.get_timeline(:tracker_id, {:project_ids => 15041, :category_ids => 15042}, nil)
    timeline.size.should == 2
    timeline[0].range_type.should == 'weeks'
    timeline[0].grouping.should == 'tracker_id'
    timeline[0].range_value.should == 2010009
    timeline[0].group_id.to_i.should == 2
    timeline[0].logged_hours.should be_within(1).of(16.5)
    timeline[0].entries.should == 5
    timeline[1].range_value.should == 2010010
    timeline[1].group_id.to_i.should == 1
    timeline[1].logged_hours.should be_within(1).of(8.9)
    timeline[1].entries.should == 3
  end

  it "should timeline_condition_user_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :user_ids => 2}, nil)
    timeline.size.should == 3
  end

  it "should timeline_condition_issue_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :issue_id => 15041}, nil)
    timeline.size.should == 4
  end

  it "should timeline_condition_activity_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :activity_ids => 9}, nil)
    timeline.size.should == 3
  end

  it "should timeline_condition_category_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :category_ids => 15042}, nil)
    timeline.size.should == 2
  end

  it "should timeline_condition_tracker_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :tracker_ids => 1}, nil)
    timeline.size.should == 3
  end

  it "should timeline_condition_fixed_version_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :fixed_version_id => 15042}, nil)
    timeline.size.should == 4
  end

  it "should timeline_condition_priority_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :priority_ids => 5}, nil)
    timeline.size.should == 2
  end

  it "should timeline_condition_author_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :author_ids => 1}, nil)
    timeline.size.should == 4
  end

  it "should timeline_condition_status_ids" do
    timeline, range = ChartTimeEntry.get_timeline(nil, {:project_ids => 15041, :status_ids => 1}, nil)
    timeline.size.should == 1
  end

  it "should aggregation_for_issue" do
    aggregation = ChartTimeEntry.get_aggregation_for_issue({:project_ids => 15041}, {:range => :weeks, :limit => 10, :offset => 0})
    aggregation.size.should == 5
    aggregation[0].should be_within(1).of(5.1)
    aggregation[15043].should be_within(1).of(7.6)
    aggregation[15044].should be_within(1).of(8.9)
    aggregation[15045].should be_within(1).of(8.9)
    aggregation[15041].should be_within(1).of(5.5)
  end

end
