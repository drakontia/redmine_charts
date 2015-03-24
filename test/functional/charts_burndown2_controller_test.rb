require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_burndown2_controller'

class ChartsBurndown2ControllerTest < ChartsControllerTest
  def setup
    Time.set_current_date = Time.mktime(2010, 4, 16)
    @controller = ChartsBurndown2Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  def test_get_data
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, fixed_version_ids: [15_042]

    assert_equal l(:charts_burndown2_y), body['y_legend']['text']
    assert_equal l(:charts_burndown2_x), body['x_legend']['text']
    assert_in_delta 24, body['y_axis']['max'], 1
    assert_equal 0, body['y_axis']['min']
    assert_in_delta 42, body['x_axis']['max'], 1
    assert_equal 0, body['x_axis']['min']
    assert_equal 43, body['x_axis']['labels']['labels'].size
    assert_equal '20 Mar 10', body['x_axis']['labels']['labels'][0]
    assert_equal '29 Apr 10', body['x_axis']['labels']['labels'][40]

    assert_equal 2, body['elements'].size
    assert_equal 43, body['elements'][0]['values'].size
    assert_equal l(:charts_burndown2_group_velocity), body['elements'][0]['text']
    assert_equal 28, body['elements'][1]['values'].size
    assert_equal l(:charts_burndown2_group_burndown), body['elements'][1]['text']

    assert_in_delta 20, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown2_hint_velocity, remaining_hours: 20.0)}<br>#{'20 Mar 10'}", body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 10.7, body['elements'][0]['values'][20]['value'], 0.1
    assert_equal "#{l(:charts_burndown2_hint_velocity, remaining_hours: 10.7)}<br>#{'09 Apr 10'}", body['elements'][0]['values'][20]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][42]['value'], 0.1
    assert_equal "#{l(:charts_burndown2_hint_velocity, remaining_hours: 0.0)}<br>#{'01 May 10'}", body['elements'][0]['values'][42]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_in_delta 11.0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 60)}<br>#{'20 Mar 10'}", body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 11.0, body['elements'][1]['values'][27]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 60)}<br>#{'16 Apr 10'}", body['elements'][1]['values'][27]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_nil body['elements'][1]['values'][28]
  end

  def test_sub_tasks
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data project_id: 15_044, fixed_version_ids: [15_043]

      assert_in_delta 12, body['elements'][0]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown2_hint_velocity, remaining_hours: 12.0)}<br>#{'20 Mar 10'}", body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

      assert_in_delta 12.0, body['elements'][1]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 12.0, work_done: 0)}<br>#{'20 Mar 10'}", body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    end
  end
end
