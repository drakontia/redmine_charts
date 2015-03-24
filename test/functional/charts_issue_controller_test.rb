require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_issue_controller'

class ChartsIssueControllerTest < ChartsControllerTest
  def setup
    @controller = ChartsIssueController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_range
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: [15_041, 15_042]

    assert_equal 3, body['elements'][0]['values'].size

    assert_equal 'New', body['elements'][0]['values'][0]['label']
    assert_in_delta 1, body['elements'][0]['values'][0]['value'], 1
    assert_equal "#{l(:charts_issue_hint, label: 'New', issues: 1, percent: 20, total_issues: 5)}",
                 body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 'Assigned', body['elements'][0]['values'][1]['label']
    assert_in_delta 3, body['elements'][0]['values'][1]['value'], 1
    assert_equal "#{l(:charts_issue_hint, label: 'Assigned', issues: 3, percent: 60, total_issues: 5)}",
                 body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 'Resolved', body['elements'][0]['values'][2]['label']
    assert_in_delta 1, body['elements'][0]['values'][2]['value'], 1
    assert_equal "#{l(:charts_issue_hint, label: 'Resolved', issues: 1, percent: 20, total_issues: 5)}",
                 body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_sub_tasks
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data project_id: 15_044, project_ids: [15_044]

      assert_equal 1, body['elements'][0]['values'].size

      assert_equal 'Resolved', body['elements'][0]['values'][0]['label']
      assert_in_delta 4, body['elements'][0]['values'][0]['value'], 1
      assert_equal "#{l(:charts_issue_hint, label: 'Resolved', issues: 4, percent: 100, total_issues: 4)}",
                   body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    end
  end
end
