require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
module TimeEntryPatch
describe "TimeEntryPatch" do

  before do
    Time.set_current_date = Time.mktime(2010,4,16)
    @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create')

    @issue.save
  end

  it "should not work charts time_entry" do
    expect(ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}).size).to eq(0)
  end

  it "should add charts time entry" do
    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 2, :spent_on => Time.mktime(2010,3,11))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries.size).to eq(2)

    expect(time_entries[0].day).to eq(2010070)
    expect(time_entries[0].week).to eq(2010010)
    expect(time_entries[0].month).to eq(2010003)
    expect(time_entries[0].issue_id).to eq(@issue.id)
    expect(time_entries[0].project_id).to eq(15041)
    expect(time_entries[0].activity_id).to eq(9)
    expect(time_entries[0].user_id).to eq(1)
    expect(time_entries[0].logged_hours).to eq(2)
    expect(time_entries[0].entries).to eq(1)

    expect(time_entries[1].day).to eq(0)
    expect(time_entries[1].week).to eq(0)
    expect(time_entries[1].month).to eq(0)
    expect(time_entries[1].issue_id).to eq(@issue.id)
    expect(time_entries[1].project_id).to eq(15041)
    expect(time_entries[1].activity_id).to eq(9)
    expect(time_entries[1].user_id).to eq(1)
    expect(time_entries[1].logged_hours).to eq(2)
    expect(time_entries[1].entries).to eq(1)

    time_entry = tmp_time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 10, :spent_on => Time.mktime(2010,3,11))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries.size).to eq(2)

    expect(time_entries[0].day).to eq(2010070)
    expect(time_entries[0].issue_id).to eq(@issue.id)
    expect(time_entries[0].activity_id).to eq(9)
    expect(time_entries[0].user_id).to eq(1)
    expect(time_entries[0].logged_hours).to eq(12)
    expect(time_entries[0].entries).to eq(2)

    expect(time_entries[1].day).to eq(0)
    expect(time_entries[1].issue_id).to eq(@issue.id)
    expect(time_entries[1].activity_id).to eq(9)
    expect(time_entries[1].user_id).to eq(1)
    expect(time_entries[1].logged_hours).to eq(12)
    expect(time_entries[1].entries).to eq(2)

    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 9, :hours => 1, :spent_on => Time.mktime(2010,3,12))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries.size).to eq(3)

    expect(time_entries[0].day).to eq(2010070)
    expect(time_entries[0].issue_id).to eq(@issue.id)
    expect(time_entries[0].activity_id).to eq(9)
    expect(time_entries[0].user_id).to eq(1)
    expect(time_entries[0].logged_hours).to eq(12)
    expect(time_entries[0].entries).to eq(2)

    expect(time_entries[1].day).to eq(0)
    expect(time_entries[1].issue_id).to eq(@issue.id)
    expect(time_entries[1].activity_id).to eq(9)
    expect(time_entries[1].user_id).to eq(1)
    expect(time_entries[1].logged_hours).to eq(13)
    expect(time_entries[1].entries).to eq(3)

    expect(time_entries[2].day).to eq(2010071)
    expect(time_entries[2].issue_id).to eq(@issue.id)
    expect(time_entries[2].activity_id).to eq(9)
    expect(time_entries[2].user_id).to eq(1)
    expect(time_entries[2].logged_hours).to eq(1)
    expect(time_entries[2].entries).to eq(1)

    time_entry = TimeEntry.new(:issue_id => @issue.id, :activity_id => 10, :hours => 1, :spent_on => Time.mktime(2010,3,12))
    time_entry.user_id = 1

    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries.size).to eq(5)

    expect(time_entries[0].day).to eq(2010070)
    expect(time_entries[0].issue_id).to eq(@issue.id)
    expect(time_entries[0].activity_id).to eq(9)
    expect(time_entries[0].user_id).to eq(1)
    expect(time_entries[0].logged_hours).to eq(12)
    expect(time_entries[0].entries).to eq(2)

    expect(time_entries[1].day).to eq(0)
    expect(time_entries[1].issue_id).to eq(@issue.id)
    expect(time_entries[1].activity_id).to eq(9)
    expect(time_entries[1].user_id).to eq(1)
    expect(time_entries[1].logged_hours).to eq(13)
    expect(time_entries[1].entries).to eq(3)

    expect(time_entries[2].day).to eq(2010071)
    expect(time_entries[2].issue_id).to eq(@issue.id)
    expect(time_entries[2].activity_id).to eq(9)
    expect(time_entries[2].user_id).to eq(1)
    expect(time_entries[2].logged_hours).to eq(1)
    expect(time_entries[2].entries).to eq(1)

    expect(time_entries[3].day).to eq(2010071)
    expect(time_entries[3].issue_id).to eq(@issue.id)
    expect(time_entries[3].activity_id).to eq(10)
    expect(time_entries[3].user_id).to eq(1)
    expect(time_entries[3].logged_hours).to eq(1)
    expect(time_entries[3].entries).to eq(1)

    expect(time_entries[4].day).to eq(0)
    expect(time_entries[4].issue_id).to eq(@issue.id)
    expect(time_entries[4].activity_id).to eq(10)
    expect(time_entries[4].user_id).to eq(1)
    expect(time_entries[4].logged_hours).to eq(1)
    expect(time_entries[4].entries).to eq(1)

    time_entry.hours = 2
    time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries[3].day).to eq(2010071)
    expect(time_entries[3].issue_id).to eq(@issue.id)
    expect(time_entries[3].activity_id).to eq(10)
    expect(time_entries[3].user_id).to eq(1)
    expect(time_entries[3].logged_hours).to eq(2)
    expect(time_entries[3].entries).to eq(1)

    expect(time_entries[4].day).to eq(0)
    expect(time_entries[4].issue_id).to eq(@issue.id)
    expect(time_entries[4].activity_id).to eq(10)
    expect(time_entries[4].user_id).to eq(1)
    expect(time_entries[4].logged_hours).to eq(2)
    expect(time_entries[4].entries).to eq(1)

    tmp_time_entry.hours = 20
    tmp_time_entry.save

    time_entries = ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

    expect(time_entries[0].day).to eq(2010070)
    expect(time_entries[0].issue_id).to eq(@issue.id)
    expect(time_entries[0].activity_id).to eq(9)
    expect(time_entries[0].user_id).to eq(1)
    expect(time_entries[0].logged_hours).to eq(22)
    expect(time_entries[0].entries).to eq(2)

    expect(time_entries[1].day).to eq(0)
    expect(time_entries[1].issue_id).to eq(@issue.id)
    expect(time_entries[1].activity_id).to eq(9)
    expect(time_entries[1].user_id).to eq(1)
    expect(time_entries[1].logged_hours).to eq(23)
    expect(time_entries[1].entries).to eq(3)

    @issue.destroy

    expect(ChartTimeEntry.all(:conditions => {:issue_id => @issue.id}).size).to eq(0)
  end

end
end
end
