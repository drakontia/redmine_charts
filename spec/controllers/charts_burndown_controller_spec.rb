require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsBurndownController do

  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010,3,12)
    @controller = ChartsBurndownController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Setting.default_language = 'en'
    @request.session['user_id'] = 1
  end

  it "should return data with range days limit 4 offset 1" do
    get :index, :project_id => 15041, :project_ids => [15041, 15042], :limit => '4', :range => 'days', :offset => '1'
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['y_legend']['text'].should == l(:charts_burndown_y)
    body['x_legend']['text'].should == l(:charts_burndown_x)
    body['y_axis']['max'].should be_within( 1).of(81)
    body['y_axis']['min'].should == 0
    body['x_axis']['max'].should be_within( 1).of(4)
    body['x_axis']['min'].should == 0
    body['x_axis']['labels']['labels'].size.should == 4
    body['x_axis']['labels']['labels'][0].should == '08 Mar 10'
    body['x_axis']['labels']['labels'][1].should == '09 Mar 10'
    body['x_axis']['labels']['labels'][2].should == '10 Mar 10'
    body['x_axis']['labels']['labels'][3].should == '11 Mar 10'

    body['elements'].size.should == 4
    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == l(:charts_burndown_group_estimated)
    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_burndown_group_logged)
    body['elements'][2]['values'].size.should == 4
    body['elements'][2]['text'].should == l(:charts_burndown_group_remaining)
    body['elements'][3]['values'].size.should == 4
    body['elements'][3]['text'].should == l(:charts_burndown_group_predicted)

    body['elements'][0]['values'][0]['value'].should be_within(0.1).of(23)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 23.0)}<br>#{'08 Mar 10'}"
    body['elements'][0]['values'][1]['value'].should be_within(0.1).of(35)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'09 Mar 10'}"
    body['elements'][0]['values'][2]['value'].should be_within(0.1).of(35)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'10 Mar 10'}"
    body['elements'][0]['values'][3]['value'].should be_within(0.1).of(35)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>#{'11 Mar 10'}"

    body['elements'][1]['values'][0]['value'].should be_within(0.1).of(29.35)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 29.4)}<br>#{'08 Mar 10'}"
    body['elements'][1]['values'][1]['value'].should be_within(0.1).of(35.95)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 36.0)}<br>#{'09 Mar 10'}"
    body['elements'][1]['values'][2]['value'].should be_within(0.1).of(43.35)
    body['elements'][1]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>#{'10 Mar 10'}"
    body['elements'][1]['values'][3]['value'].should be_within(0.1).of(43.35)
    body['elements'][1]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>#{'11 Mar 10'}"

    body['elements'][2]['values'][0]['value'].should be_within(0.1).of(5.1)
    body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 5.1, :work_done => 90)}<br>#{'08 Mar 10'}"
    body['elements'][2]['values'][1]['value'].should be_within(0.1).of(31.5)
    body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 31.5, :work_done => 76)}<br>#{'09 Mar 10'}"
    body['elements'][2]['values'][2]['value'].should be_within(0.1).of(11.0)
    body['elements'][2]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>#{'10 Mar 10'}"
    body['elements'][2]['values'][3]['value'].should be_within(0.1).of(11.0)
    body['elements'][2]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>#{'11 Mar 10'}"

    body['elements'][3]['values'][0]['value'].should be_within(0.1).of(34.4)
    body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 34.5, :hours_over_estimation => 11.5)}<br>#{'08 Mar 10'}"
    body['elements'][3]['values'][1]['value'].should be_within(0.1).of(67.4)
    body['elements'][3]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 67.5, :hours_over_estimation => 32.5)}<br>#{'09 Mar 10'}"
    body['elements'][3]['values'][2]['value'].should be_within(0.1).of(54.4)
    body['elements'][3]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>#{'10 Mar 10'}"
    body['elements'][3]['values'][3]['value'].should be_within(0.1).of(54.4)
    body['elements'][3]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>#{'11 Mar 10'}"

  end

  it "should return data with range weeks limit 1 if it has sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, :project_id => 15044, :project_ids => [15044], :limit => '1', :range => 'weeks', :offset => '0'
      response.should be_success

      body = ActiveSupport::JSON.decode(assigns[:data])
      body['elements'][0]['values'].size.should == 1

      body['elements'][0]['values'][0]['value'].should be_within(0.1).of(12)
      body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_estimated, :estimated_hours => 12.0)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][1]['values'][0]['value'].should be_within(0.1).of(13.2)
      body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_logged, :logged_hours => 13.2)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][2]['values'][0]['value'].should be_within(0.1).of(12)
      body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.0, :work_done => 0)}<br>#{'8 - 14 Mar 10'}"

      body['elements'][3]['values'][0]['value'].should be_within(0.1).of(25.2)
      body['elements'][3]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 25.2, :hours_over_estimation => 13.2)}<br>#{'8 - 14 Mar 10'}"
    end
  end

end
