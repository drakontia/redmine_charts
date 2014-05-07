require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsBurndown2Controller do

  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010,4,16)
    @controller = ChartsBurndown2Controller.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1
    Setting.default_language = 'en'
  end

  it "should return data with grouping by fixed version" do
    get :index, :project_id => 15041, :fixed_version_ids => [15042]
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:chart].render)
    body['y_legend']['text'].should == l(:charts_burndown2_y)
    body['x_legend']['text'].should == l(:charts_burndown2_x)
    body['y_axis']['max'].should be_within(1).of(24)
    body['y_axis']['min'].should == 0
    body['x_axis']['max'].should be_within(1).of(42)
    body['x_axis']['min'].should == 0
    body['x_axis']['labels']['labels'].size.should == 43
    body['x_axis']['labels']['labels'][0].should == '20 Mar 10'
    body['x_axis']['labels']['labels'][40].should == '29 Apr 10'

    body['elements'].size.should == 2
    body['elements'][0]['values'].size.should == 43
    body['elements'][0]['text'].should == l(:charts_burndown2_group_velocity)
    body['elements'][1]['values'].size.should == 28
    body['elements'][1]['text'].should == l(:charts_burndown2_group_burndown)

    body['elements'][0]['values'][0]['value'].should be_within(0.1).of(20)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown2_hint_velocity, :remaining_hours => 20.0)}<br>#{'20 Mar 10'}"
    body['elements'][0]['values'][20]['value'].should be_within(0.1).of(10.7)
    body['elements'][0]['values'][20]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown2_hint_velocity, :remaining_hours => 10.7)}<br>#{'09 Apr 10'}"
    body['elements'][0]['values'][42]['value'].should be_within(0.1).of(0)
    body['elements'][0]['values'][42]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown2_hint_velocity, :remaining_hours => 0.0)}<br>#{'01 May 10'}"

    body['elements'][1]['values'][0]['value'].should be_within(0.1).of(11.0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 60)}<br>#{'20 Mar 10'}"
    body['elements'][1]['values'][27]['value'].should be_within(0.1).of(11.0)
    body['elements'][1]['values'][27]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 60)}<br>#{'16 Apr 10'}"
    body['elements'][1]['values'][28].should be_nil

  end

  it "should return data if it has sub tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, :project_id => 15044, :fixed_version_ids => [15043]
      response.should be_success

      body = ActiveSupport::JSON.decode(assigns[:chart].render)
      body['elements'][0]['values'][0]['value'].should be_within(0.1).of(12)
      body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown2_hint_velocity, :remaining_hours => 12.0)}<br>#{'20 Mar 10'}"

      body['elements'][1]['values'][0]['value'].should be_within(0.1).of(12.0)
      body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == "#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.0, :work_done => 0)}<br>#{'20 Mar 10'}"
    end
  end

end
