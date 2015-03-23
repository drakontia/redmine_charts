require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
module IssuePatch
  describe "IssuePatch" do

    before do
      Time.set_current_date = Time.mktime(2010,3,11)

      @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create')
      @issue.save
    end

    it "should add issue_status" do

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      expect(issue_status.size).to eq(1)

      expect(issue_status[0].day).to eq(2010070)
      expect(issue_status[0].week).to eq(2010010)
      expect(issue_status[0].month).to eq(2010003)
      expect(issue_status[0].issue_id).to eq(@issue.id)
      expect(issue_status[0].project_id).to eq(15041)
      expect(issue_status[0].status_id).to eq(1)
    end

    it "should change issue_status if status is assigned" do
      @issue.status_id = 2
      @issue.save

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      expect(issue_status.size).to eq(1)
      expect(issue_status[0].status_id).to eq(2)
    end

    it "should add new issue_status if status is resolved" do
      @issue.status_id = 2
      @issue.save
      Time.set_current_date = Time.mktime(2010,3,12)

      @issue.status_id = 3
      @issue.save

      issue_status = ChartIssueStatus.all(:conditions => {:issue_id => @issue.id})

      expect(issue_status.size).to eq(2)

      expect(issue_status[0].status_id).to eq(2)
      expect(issue_status[1].status_id).to eq(3)

      @issue.destroy
    end

    it "should set done_ratio if status is finished" do
      @issue.status_id = 5
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id})

      expect(done_ratio.size).to eq(2)

      expect(done_ratio[0].done_ratio).to eq(100)
      expect(done_ratio[1].done_ratio).to eq(100)

      @issue.destroy
    end

    it "should add done_ratio" do
      expect(ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size).to eq(0)

      @issue.done_ratio = 10
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      expect(done_ratio.size).to eq(2)

      expect(done_ratio[0].day).to eq(0)
      expect(done_ratio[0].week).to eq(0)
      expect(done_ratio[0].month).to eq(0)
      expect(done_ratio[0].issue_id).to eq(@issue.id)
      expect(done_ratio[0].project_id).to eq(15041)
      expect(done_ratio[0].done_ratio).to eq(10)

      expect(done_ratio[1].day).to eq(2010070)
      expect(done_ratio[1].week).to eq(2010010)
      expect(done_ratio[1].month).to eq(2010003)
      expect(done_ratio[1].issue_id).to eq(@issue.id)
      expect(done_ratio[1].project_id).to eq(15041)
      expect(done_ratio[1].done_ratio).to eq(10)
    end

    it "should get 2 done_ratio" do
      @issue.done_ratio = 10
      @issue.save

      @issue.done_ratio = 20
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      expect(done_ratio.size).to eq(2)
      expect(done_ratio[0].done_ratio).to eq(20)
      expect(done_ratio[1].done_ratio).to eq(20)
    end

    it "should get 3 done_ratio" do
      @issue.done_ratio = 10
      @issue.save

      @issue.done_ratio = 20
      @issue.save

      Time.set_current_date = Time.mktime(2010,3,12)
      @issue.done_ratio = 30
      @issue.save

      done_ratio = ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}, :order => "id asc")

      expect(done_ratio.size).to eq(3)
      expect(done_ratio[0].done_ratio).to eq(30)
      expect(done_ratio[1].done_ratio).to eq(20)
      expect(done_ratio[2].done_ratio).to eq(30)
    end

    it "should delete done_ratio if issues deleted" do
      @issue.done_ratio = 10
      @issue.save

      @issue.destroy

      expect(ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size).to eq(0)
    end

    it "should create done_ratio with done_ratio" do
      @issue = Issue.new(:project_id => 15041, :tracker_id => 1, :author_id => 1, :status_id => 1, :priority => IssuePriority.all.first, :subject => 'test_create', :description => 'IssueTest#test_create', :done_ratio => 20)
      @issue.save


      expect(ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size).to eq(2)

      @issue.destroy

      expect(ChartDoneRatio.all(:conditions => {:issue_id => @issue.id}).size).to eq(0)
    end

  end
end
end
