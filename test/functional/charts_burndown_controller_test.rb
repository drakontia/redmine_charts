require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_burndown_controller'

class ChartsBurndownControllerTest < ChartsControllerTest
  def setup
    Time.set_current_date = Time.mktime(2010, 3, 12)
    @controller = ChartsBurndownController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  def test_get_data
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: [15_041, 15_042], limit: '4', range: 'days', offset: '1'

    assert_equal l(:charts_burndown_y), body['y_legend']['text']
    assert_equal l(:charts_burndown_x), body['x_legend']['text']
    assert_in_delta 81, body['y_axis']['max'], 1
    assert_equal 0, body['y_axis']['min']
    assert_in_delta 4, body['x_axis']['max'], 1
    assert_equal 0, body['x_axis']['min']
    assert_equal 4, body['x_axis']['labels']['labels'].size
    assert_equal '08 Mar 10', body['x_axis']['labels']['labels'][0]
    assert_equal '09 Mar 10', body['x_axis']['labels']['labels'][1]
    assert_equal '10 Mar 10', body['x_axis']['labels']['labels'][2]
    assert_equal '11 Mar 10', body['x_axis']['labels']['labels'][3]

    assert_equal 4, body['elements'].size
    assert_equal 4, body['elements'][0]['values'].size
    assert_equal l(:charts_burndown_group_estimated), body['elements'][0]['text']
    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_burndown_group_logged), body['elements'][1]['text']
    assert_equal 4, body['elements'][2]['values'].size
    assert_equal l(:charts_burndown_group_remaining), body['elements'][2]['text']
    assert_equal 4, body['elements'][3]['values'].size
    assert_equal l(:charts_burndown_group_predicted), body['elements'][3]['text']

    assert_in_delta 23, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, estimated_hours: 23.0)}<br>#{'08 Mar 10'}", body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 35, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, estimated_hours: 35.0)}<br>#{'09 Mar 10'}", body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 35, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, estimated_hours: 35.0)}<br>#{'10 Mar 10'}", body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 35, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_estimated, estimated_hours: 35.0)}<br>#{'11 Mar 10'}", body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_in_delta 29.35, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, logged_hours: 29.4)}<br>#{'08 Mar 10'}", body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 35.95, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, logged_hours: 36.0)}<br>#{'09 Mar 10'}", body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 43.35, body['elements'][1]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, logged_hours: 43.4)}<br>#{'10 Mar 10'}", body['elements'][1]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 43.35, body['elements'][1]['values'][3]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_logged, logged_hours: 43.4)}<br>#{'11 Mar 10'}", body['elements'][1]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_in_delta 5.1, body['elements'][2]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 5.1, work_done: 90)}<br>#{'08 Mar 10'}", body['elements'][2]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 31.5, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 31.5, work_done: 76)}<br>#{'09 Mar 10'}", body['elements'][2]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 11.0, body['elements'][2]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 84)}<br>#{'10 Mar 10'}", body['elements'][2]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 11.0, body['elements'][2]['values'][3]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 84)}<br>#{'11 Mar 10'}", body['elements'][2]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_in_delta 34.4, body['elements'][3]['values'][0]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, predicted_hours: 34.5, hours_over_estimation: 11.5)}<br>#{'08 Mar 10'}", body['elements'][3]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 67.4, body['elements'][3]['values'][1]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, predicted_hours: 67.5, hours_over_estimation: 32.5)}<br>#{'09 Mar 10'}", body['elements'][3]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 54.4, body['elements'][3]['values'][2]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, predicted_hours: 54.4, hours_over_estimation: 19.4)}<br>#{'10 Mar 10'}", body['elements'][3]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 54.4, body['elements'][3]['values'][3]['value'], 0.1
    assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, predicted_hours: 54.4, hours_over_estimation: 19.4)}<br>#{'11 Mar 10'}", body['elements'][3]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_sub_tasks
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data project_id: 15_044, project_ids: [15_044], limit: '1', range: 'weeks', offset: '0'

      assert_equal 1, body['elements'][0]['values'].size

      assert_in_delta 12, body['elements'][0]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown_hint_estimated, estimated_hours: 12.0)}<br>#{'8 - 14 Mar 10'}", body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

      assert_in_delta 13.2, body['elements'][1]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown_hint_logged, logged_hours: 13.2)}<br>#{'8 - 14 Mar 10'}", body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

      assert_in_delta 12, body['elements'][2]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown_hint_remaining, remaining_hours: 12.0, work_done: 0)}<br>#{'8 - 14 Mar 10'}", body['elements'][2]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

      assert_in_delta 25.2, body['elements'][3]['values'][0]['value'], 0.1
      assert_equal "#{l(:charts_burndown_hint_predicted_over_estimation, predicted_hours: 25.2, hours_over_estimation: 13.2)}<br>#{'8 - 14 Mar 10'}", body['elements'][3]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    end
  end
end
