require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsRatioController do

  include Redmine::I18n

  before do
    Setting.default_language = 'en'
    @controller = ChartsRatioController.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1
  end

  it "should return data with grouping by users" do
    get :index, :project_id => 15041, :project_ids => [15041]

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][0]["label"].should == 'John Smith'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(16.8)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'John Smith', :hours => 16.8, :percent => 47, :total_hours => 36.1)}"

    body['elements'][0]['values'][1]["label"].should == 'Redmine Admin'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(14.2)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'redMine Admin', :hours => 14.2, :percent => 39, :total_hours => 36.1)}"

    body['elements'][0]['values'][2]["label"].should == 'Dave Lopper'
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Dave Lopper', :hours => 5.1, :percent => 14, :total_hours => 36.1)}"

  end

  it "should return data with grouping_by_activities" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :activity_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 2

    body['elements'][0]['values'][1]["label"].should == 'Design'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(10.2)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Design', :hours => 10.2, :percent => 28, :total_hours => 36.1)}"

    body['elements'][0]['values'][0]["label"].should == 'Development'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(25.8)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Development', :hours => 25.9, :percent => 72, :total_hours => 36.1)}"

  end

  it "should return data with grouping by priorities" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :priority_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][1]["label"].should == 'Low'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(13)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Low', :hours => 13.2, :percent => 36, :total_hours => 36.1)}"

    body['elements'][0]['values'][2]["label"].should == l(:charts_ratio_others)
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}"
  end

  it "should return with grouping by trackers" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :tracker_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][1]["label"].should == 'Bug'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(14)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Bug', :hours => 14.5, :percent => 40, :total_hours => 36.1)}"

    body['elements'][0]['values'][2]["label"].should == l(:charts_ratio_others)
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}"
  end

  it "should return data with grouping by issues" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :issue_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 5

    body['elements'][0]['values'][1]["label"].should == '#15045 Issue5'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(8.9)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '#15045 Issue5', :hours => 8.9, :percent => 25, :total_hours => 36.1)}"

    body['elements'][0]['values'][0]["label"].should == '#15044 Issue4'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(8.9)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '#15044 Issue4', :hours => 8.9, :percent => 25, :total_hours => 36.1)}"

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][2]["label"].should == '#15043 Issue3'
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(7.6)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '#15043 Issue3', :hours => tmp, :percent => 21, :total_hours => 36.1)}"

    body['elements'][0]['values'][3]["label"].should == '#15041 Issue1'
    body['elements'][0]['values'][3]["value"].should be_within( 1).of(5.5)
    body['elements'][0]['values'][3]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '#15041 Issue1', :hours => 5.6, :percent => 15, :total_hours => 36.1)}"

    body['elements'][0]['values'][4]["label"].should == l(:charts_ratio_others)
    body['elements'][0]['values'][4]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][4]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}"
  end

  it "should return data with grouping by versions" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :fixed_version_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][1]["label"].should == '1.0'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(14.5)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '1.0', :hours => 14.5, :percent => 40, :total_hours => 36.1)}"

    body['elements'][0]['values'][2]["label"].should == l(:charts_ratio_others)
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}"

    body['elements'][0]['values'][0]["label"].should == '2.0'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(16.5)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => '2.0', :hours => 16.5, :percent => 46, :total_hours => 36.1)}"
  end

  it "should return data with grouping by categories" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :category_id

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    body['elements'][0]['values'][0]["label"].should == 'Category2'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(25.4)
    body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Category2', :hours => 25.4, :percent => 70, :total_hours => 36.1)}"

    body['elements'][0]['values'][1]["label"].should == 'Category1'
    body['elements'][0]['values'][1]["value"].should be_within( 1).of(5.55)
    body['elements'][0]['values'][1]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'Category1', :hours => 5.6, :percent => 15, :total_hours => 36.1)}"

    body['elements'][0]['values'][2]["label"].should == l(:charts_ratio_others)
    body['elements'][0]['values'][2]["value"].should be_within( 1).of(5.1)
    body['elements'][0]['values'][2]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")   .should == "#{l(:charts_ratio_hint, :label => l(:charts_ratio_others), :hours => 5.1, :percent => 14, :total_hours => 36.1)}"
  end

  it "should return data with users condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :user_id, :user_ids => 1

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'Redmine Admin'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(14)
  end

  it "should return data with issues_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => 'issue_id', :issue_ids => 15041

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == '#15041 Issue1'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(6)
  end

  it "should return data with activities_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => 'activity_id', :activity_ids => 10

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'Development'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(26)
  end

  it "should return data with priorities_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :priority_id, :priority_ids => 5

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'Normal'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(17.8)
  end

  it "should return data with trackers_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :tracker_id, :tracker_ids => 1

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'Bug'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(14)
  end

  it "should return data with versions_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :fixed_version_id, :fixed_version_ids => 15041

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == '1.0'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(14.5)
  end

  it "should return data with categories_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :category_id, :category_ids => 15041

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'Category1'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(5.55)
  end

  it "should return data with authors_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :author_id, :author_ids => 2

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'John Smith'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(8.9)
  end

  it "should return data with statuses_condition" do
    get :index, :project_id => 15041, :project_ids => [15041], :grouping => :status_id, :status_ids => 1

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 1
    body['elements'][0]['values'][0]["label"].should == 'New'
    body['elements'][0]['values'][0]["value"].should be_within( 1).of(8.9)
  end

  it "should return data with all_conditions" do
    get :index, :project_id => 15041, :project_ids => [15041], :author_ids => 2, :status_ids => 1, :category_ids => 15043, :tracker_ids => 15043, :fixed_version_ids => 15043, :priority_ids => 15041, :user_ids => 15043, :issue_ids => 15043, :activity_ids => 15043
    response.should be_success
  end

  it "should not return data when it's empty" do
    get :index, :project_id => 15041, :project_ids => [15041], :category_ids => 15043, :fixed_version_ids => 15041
    response.should be_success

  end

  it "should return data if issues has sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, :project_id => 15044, :project_ids => [15044]

      body = ActiveSupport::JSON.decode(assigns[:data])
      body['elements'][0]['values'].size.should == 1

      body['elements'][0]['values'][0]["label"].should == 'John Smith'
      body['elements'][0]['values'][0]["value"].should be_within( 1).of(13.2)
      body['elements'][0]['values'][0]["tip"].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_ratio_hint, :label => 'John Smith', :hours => 13.2, :percent => 100, :total_hours => 13.2)}"
    end
  end

end
