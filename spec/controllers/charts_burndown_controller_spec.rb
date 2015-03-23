require File.dirname(__FILE__) + '/../rails_helper'

Rspec.describe ChartsBurndownController, type: :controller do
  describe 'GET #index' do
  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010, 3, 12)
    @controller = ChartsBurndownController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Setting.default_language = 'en'
  end

  it 'return data with range days limit 4 offset 1' do
    get :index, project_id: 15041, project_ids: [15041, 15042], limit: '4', range: 'days', offset: '1'
    expect(response).to be_success
    expect(response).to have_http_status(200)

    #body = ActiveSupport::JSON.decode(assigns[:data])
    expect(assigns(:data).y_legend.text).to eq l(:charts_burndown_y)
    expect(assigns(:data).x_legend.text).to eq l(:charts_burndown_x)
    expect(assigns(:data).y_axis.max).to be_within(81, 1)
    expect(assigns(:data).y_axis.min).to eq 0
    expect(assigns(:data).x_axis.max).to be_within(4, 1)
    expect(assigns(:data).x_axis.min).to eq 0
    expect(assigns(:data).x_axis.labels.labels.size).to eq 4
    expect(assigns(:data).x_axis.labels.labels[0]).to eq '08 Mar 10'
    expect(assigns(:data).x_axis.labels.labels[1]).to eq '09 Mar 10'
    expect(assigns(:data).x_axis.labels.labels[2]).to eq '10 Mar 10'
    expect(assigns(:data).x_axis.labels.labels[3]).to eq '11 Mar 10'

    expect(assigns(:data).elements.size).to eq 4
    expect(assigns(:data).elements[0].values.size).to eq 4
    expect(assigns(:data).elements[0].text).to eq l(:charts_burndown_group_estimated)
    expect(assigns(:data).elements[1].values.size).to eq 4
    expect(assigns(:data).elements[1].text).to eq l(:charts_burndown_group_logged)
    expect(assigns(:data).elements[2].values.size).to eq 4
    expect(assigns(:data).elements[2].text).to eq l(:charts_burndown_group_remaining)
    expect(assigns(:data).elements[3].values.size).to eq 4
    expect(assigns(:data).elements[3].text).to eq l(:charts_burndown_group_predicted)

    expect(assigns(:data).elements[0].values[0].value).to be_within(0[1]).of(23)
    expect(assigns(:data).elements[0].values[0].tip).to eq "#{l(:charts_burndown_hint_estimated, :estimated_hours => 23.0)}<br>08 Mar 10"
    expect(assigns(:data).elements[0].values[1].value).to be_within(0.1).of(35)
    expect(assigns(:data).elements[0].values[1].tip).to eq "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>09 Mar 10"
    expect(assigns(:data).elements[0].values[2].value).to be_within(35,0.1)
    expect(assigns(:data).elements[0].values[2].tip).to eq "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>10 Mar 10"
    expect(assigns(:data).elements[0].values[3].value).to be_within(35,0.1)
    expect(assigns(:data).elements[0].values[3].tip).to eq "#{l(:charts_burndown_hint_estimated, :estimated_hours => 35.0)}<br>11 Mar 10"

    expect(assigns(:data).elements[1].values[0].value).to be_within(29.35, 0.1)
    expect(assigns(:data).elements[1].values[0].tip).to eq "#{l(:charts_burndown_hint_logged, :logged_hours => 29.4)}<br>08 Mar 10"
    expect(assigns(:data).elements[1].values[1].value).to be_within(35.95,0.1)
    expect(assigns(:data).elements[1].values[1].tip).to eq "#{l(:charts_burndown_hint_logged, :logged_hours => 36.0)}<br>09 Mar 10"
    expect(assigns(:data).elements[1].values[2].value).to be_within(43.35,0.1)
    expect(assigns(:data).elements[1].values[2].tip).to eq "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>10 Mar 10"
    expect(assigns(:data).elements[1].values[3].value).to be_within(43.35,0.1)
    expect(assigns(:data).elements[1].values[3].tip).to eq "#{l(:charts_burndown_hint_logged, :logged_hours => 43.4)}<br>11 Mar 10"

    expect(assigns(:data).elements[2].values[0].value).to be_within(5.1,0.1)
    expect(assigns(:data).elements[2].values[0].tip).to eq "#{l(:charts_burndown_hint_remaining, :remaining_hours => 5.1, :work_done => 90)}<br>08 Mar 10"
    expect(assigns(:data).elements[2].values[1].value).to be_within(31.5,0.1)
    expect(assigns(:data).elements[2].values[1].tip).to eq "#{l(:charts_burndown_hint_remaining, :remaining_hours => 31.5, :work_done => 76)}<br>09 Mar 10"
    expect(assigns(:data).elements[2].values[2].value).to be_within(11.0,0.1)
    expect(assigns(:data).elements[2].values[2].tip).to eq "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>10 Mar 10"
    expect(assigns(:data).elements[2].values[3].value).to be_within(11.0,0.1)
    expect(assigns(:data).elements[2].values[3].tip).to eq "#{l(:charts_burndown_hint_remaining, :remaining_hours => 11.0, :work_done => 84)}<br>11 Mar 10"

    expect(assigns(:data).elements[3].values[0].value).to be_within(34.4,0.1)
    expect(assigns(:data).elements[3].values[0].tip).to eq "#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 34.5, :hours_over_estimation => 11.5)}<br>08 Mar 10"
    expect(assigns(:data).elements[3].values[1].value).to be_within(67.4,0.1)
    expect(assigns(:data).elements[3].values[1].tip).to match(/#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 67.5, :hours_over_estimation => 32.5)}<br>09 Mar 10/)
    expect(assigns(:data).elements[3].values[2].value).to be_within(54.4,0.1)
    expect(assigns(:data).elements[3].values[2].tip).to match(/#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>10 Mar 10/)
    expect(assigns(:data).elements[3].values[3].value).to be_within(54.4,0.1)
    expect(assigns(:data).elements[3].values[3].tip).to match(/#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 54.4, :hours_over_estimation => 19.4)}<br>11 Mar 10/)

  end

  it 'should return data with range weeks limit 1 if it has sub_tasks' do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, project_id: 15044, project_ids: [15044], limit: 1, range: 'weeks', offset: 0
      response.should be_success

      expect(assigns(:data).elements[0].values.size).to eq 1

      expect(assigns(:data).elements[0].values[0].value).to be_within(12,0.1)
      expect(assigns(:data).elements[0].values[0].tip).to match(/#{l(:charts_burndown_hint_estimated, :estimated_hours => 12.0)}<br>8 - 14 Mar 10/)

      expect(assigns(:data).elements[1].values[0].value).to be_within(13.2,0.1)
      expect(assigns(:data).elements[1].values[0].tip).to match(/#{l(:charts_burndown_hint_logged, :logged_hours => 13.2)}<br>8 - 14 Mar 10/)

      expect(assigns(:data).elements[2].values[0].value).to be_within(12,0.1)
      expect(assigns(:data).elements[2].values[0].tip).to match(/#{l(:charts_burndown_hint_remaining, :remaining_hours => 12.0, :work_done => 0)}<br>8 - 14 Mar 10/)

      expect(assigns(:data).elements[3].values[0].value).to be_within(25[2],0[1])
      expect(assigns(:data).elements[3].values[0].tip).to match(/#{l(:charts_burndown_hint_predicted_over_estimation, :predicted_hours => 25.2, :hours_over_estimation => 13.2)}<br>8 - 14 Mar 10/)
    end
  end
  end
end
