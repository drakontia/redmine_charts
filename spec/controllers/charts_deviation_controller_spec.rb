require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsDeviationController do

  include Redmine::I18n

  before do
    @controller = ChartsDeviationController.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1
  end

  it "should return data with grouping project_id" do
    get :index, :project_id => 15041, :project_ids => [15041]
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 4

    body['elements'][0]['values'][0][0]['val'].should be_within( 1).of(74.0)
    body['elements'][0]['values'][0][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 22.1)}#{l(:charts_deviation_hint_issue, :estimated_hours => 30.0, :work_done => 73)}#{l(:charts_deviation_hint_project_label)}"

    body['elements'][0]['values'][0][1]['val'].should be_within( 1).of(38.0)
    body['elements'][0]['values'][0][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 11.0, :hours_over_estimation => 3.1, :over_estimation => 12)}#{l(:charts_deviation_hint_issue, :estimated_hours => 30.0, :work_done => 73)}#{l(:charts_deviation_hint_project_label)}"

    body['elements'][0]['values'][0][2]['val'].should be_within( 1).of(42.4)
    body['elements'][0]['values'][0][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged_not_estimated, :logged_hours => 14.0)}"


    body['elements'][0]['values'][1][0]['val'].should be_within( 1).of(56.0)
    body['elements'][0]['values'][1][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 5.6)}#{l(:charts_deviation_hint_issue, :estimated_hours => 10.0, :work_done => 100)}#{l(:charts_deviation_hint_label, :issue_id => 15041, :issue_name => 'Issue1')}"

    body['elements'][0]['values'][1][1].should be_nil

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][2][0]['val'].should be_within( 1).of(95.0)
    body['elements'][0]['values'][2][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => tmp)}#{l(:charts_deviation_hint_issue, :estimated_hours => 8.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15043, :issue_name => 'Issue3')}"

    body['elements'][0]['values'][2][1]['val'].should be_within( 1).of(63.0)
    body['elements'][0]['values'][2][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 5.1, :hours_over_estimation => 4.7, :over_estimation => 58)}#{l(:charts_deviation_hint_issue, :estimated_hours => 8.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15043, :issue_name => 'Issue3')}"


    body['elements'][0]['values'][3][0]['val'].should be_within( 1).of(74.0)
    body['elements'][0]['values'][3][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 8.9)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15045, :issue_name => 'Issue5')}"

    body['elements'][0]['values'][3][1]['val'].should be_within( 1).of(49.0)
    body['elements'][0]['values'][3][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 6.0, :hours_over_estimation => 2.9, :over_estimation => 24)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 60)}#{l(:charts_deviation_hint_label, :issue_id => 15045, :issue_name => 'Issue5')}"


    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['values'][0]['y'].should == 100
    body['elements'][1]['values'][1]['y'].should == 100
    body['elements'][1]['values'][2]['y'].should == 101
    body['elements'][1]['values'][3]['y'].should == 101
    body['elements'][1]['values'][0]['x'].should == -0.45
    body['elements'][1]['values'][1]['x'].should == -0.55 + body['elements'][0]['values'].size
    body['elements'][1]['values'][2]['x'].should == -0.55 + body['elements'][0]['values'].size
    body['elements'][1]['values'][3]['x'].should == -0.45

    body['x_legend']['text'].should == l(:charts_deviation_x)
    body['y_legend']['text'].should == l(:charts_deviation_y)
    body['x_axis']['min'].should == 0
    body['x_axis']['max'].should == 3
    body['x_axis']['steps'].should == 1
    body['y_axis']['min'].should == 0
    body['y_axis']['max'].should be_within( 1).of(190)
    body['y_axis']['steps'].should be_within( 1).of(32)
    body['x_axis']['labels']['labels'][0].should == l(:charts_deviation_project_label)
    body['x_axis']['labels']['labels'][1].should == l(:charts_deviation_label, {:issue_id=>15041})
    body['x_axis']['labels']['labels'][2].should == l(:charts_deviation_label, {:issue_id=>15043})
    body['x_axis']['labels']['labels'][3].should == l(:charts_deviation_label, {:issue_id=>15045})
    body['elements'][0]['keys'][0]['text'].should == l(:charts_deviation_group_logged)
    body['elements'][0]['keys'][1]['text'].should == l(:charts_deviation_group_remaining)
    body['elements'][0]['keys'][2]['text'].should == l(:charts_deviation_group_logged_not_estimated)
    body['elements'][0]['keys'][3]['text'].should == l(:charts_deviation_group_estimated)
  end

  it "should include_subprojects" do
    get :index, :project_id => 15041, :project_ids => [15041, 15042]
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 5
  end

  it "should return data with pagination" do
    get :index, :project_id => 15041, :project_ids => [15041], :per_page => 2

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 3

    get :index, :project_id => 15041, :project_ids => [15041], :per_page => 2, :page => 2

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 2

    get :index, :project_id => 15041, :project_ids => [15041], :per_page => 2, :page => 3

    body = ActiveSupport::JSON.decode(assigns[:data])
    body.should be_nil
  end

  it "should return data if it has sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, :project_id => 15044, :project_ids => [15044]
      response.should be_success

      body = ActiveSupport::JSON.decode(assigns[:data])
      body['elements'][0]['values'].size.should == 5

      body['elements'][0]['values'][0][0]['val'].should be_within( 1).of(110.0)
      body['elements'][0]['values'][0][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 13.2)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 0)}#{l(:charts_deviation_hint_project_label)}"
      body['elements'][0]['values'][0][1]['val'].should be_within( 1).of(100.0)
      body['elements'][0]['values'][0][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 12.0, :hours_over_estimation => 13.2, :over_estimation => 110)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 0)}#{l(:charts_deviation_hint_project_label)}"

      body['elements'][0]['values'][1][0]['val'].should be_within( 1).of(110.0)
      body['elements'][0]['values'][1][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 13.2)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15047, :issue_name => 'Issue Parent')}"
      body['elements'][0]['values'][1][1]['val'].should be_within( 1).of(100.0)
      body['elements'][0]['values'][1][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 12.0, :hours_over_estimation => 13.2, :over_estimation => 110)}#{l(:charts_deviation_hint_issue, :estimated_hours => 12.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15047, :issue_name => 'Issue Parent')}"

      tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 3.4 : 3.3

      body['elements'][0]['values'][2][0]['val'].should be_within( 1).of(66.0)
      body['elements'][0]['values'][2][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 3.3)}#{l(:charts_deviation_hint_issue, :estimated_hours => 5.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15048, :issue_name => 'Issue Child 1')}"
      body['elements'][0]['values'][2][1]['val'].should be_within( 1).of(100.0)
      body['elements'][0]['values'][2][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 5.0, :hours_over_estimation => tmp, :over_estimation => 66)}#{l(:charts_deviation_hint_issue, :estimated_hours => 5.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15048, :issue_name => 'Issue Child 1')}"

      body['elements'][0]['values'][3][0]['val'].should be_within( 1).of(94.3)
      body['elements'][0]['values'][3][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 6.6)}#{l(:charts_deviation_hint_issue, :estimated_hours => 7.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15049, :issue_name => 'Issue Child 2')}"
      body['elements'][0]['values'][3][1]['val'].should be_within( 1).of(100.0)
      body['elements'][0]['values'][3][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 7.0, :hours_over_estimation => 6.6, :over_estimation => 94)}#{l(:charts_deviation_hint_issue, :estimated_hours => 7.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15049, :issue_name => 'Issue Child 2')}"

      tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 3.4 : 3.3

      body['elements'][0]['values'][4][0]['val'].should be_within( 1).of(47.1)
      body['elements'][0]['values'][4][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_logged, :logged_hours => 3.3)}#{l(:charts_deviation_hint_issue, :estimated_hours => 7.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15050, :issue_name => 'Issue Child 2.1')}"

      body['elements'][0]['values'][4][1]['val'].should be_within( 1).of(100.0)
      body['elements'][0]['values'][4][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_deviation_hint_remaining_over_estimation, :remaining_hours => 7.0, :hours_over_estimation => tmp, :over_estimation => 47)}#{l(:charts_deviation_hint_issue, :estimated_hours => 7.0, :work_done => 0)}#{l(:charts_deviation_hint_label, :issue_id => 15050, :issue_name => 'Issue Child 2.1')}"

    end
  end

end
