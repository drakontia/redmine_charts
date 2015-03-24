require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_timeline_controller'

class ChartsTimelineControllerTest < ChartsControllerTest
  def setup
    Time.set_current_date = Time.mktime(2010, 3, 12)
    @controller = ChartsTimelineController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    User.current = nil
  end

  def test_range
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, limit: 10, range: 'weeks', offset: 0

    assert_equal 0, body['x_axis']['min']
    assert_equal 1, body['x_axis']['steps']
    assert_equal 9, body['x_axis']['max']
    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal '4 - 10 Jan 10', body['x_axis']['labels']['labels'][0]
    assert_equal '', body['x_axis']['labels']['labels'][1]
    assert_equal '18 - 24 Jan 10', body['x_axis']['labels']['labels'][2]
    assert_equal '', body['x_axis']['labels']['labels'][3]
    assert_equal '1 - 7 Feb 10', body['x_axis']['labels']['labels'][4]
    assert_equal '', body['x_axis']['labels']['labels'][5]
    assert_equal '15 - 21 Feb 10', body['x_axis']['labels']['labels'][6]
    assert_equal '', body['x_axis']['labels']['labels'][7]
    assert_equal '1 - 7 Mar 10', body['x_axis']['labels']['labels'][8]
    assert_equal '', body['x_axis']['labels']['labels'][9]

    body = get_data project_id: 15_041, project_ids: 15_041, offset: 10, limit: 10, range: 'weeks'

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal '26 Oct - 1 Nov 09', body['x_axis']['labels']['labels'][0]
    assert_equal '', body['x_axis']['labels']['labels'][1]
    assert_equal '9 - 15 Nov 09', body['x_axis']['labels']['labels'][2]
    assert_equal '', body['x_axis']['labels']['labels'][3]
    assert_equal '23 - 29 Nov 09', body['x_axis']['labels']['labels'][4]
    assert_equal '', body['x_axis']['labels']['labels'][5]
    assert_equal '7 - 13 Dec 09', body['x_axis']['labels']['labels'][6]
    assert_equal '', body['x_axis']['labels']['labels'][7]
    assert_equal '21 - 27 Dec 09', body['x_axis']['labels']['labels'][8]
    assert_equal '', body['x_axis']['labels']['labels'][9]

    body = get_data project_id: 15_041, project_ids: 15_041, offset: 20, limit: 20, range: 'weeks'

    assert_equal 20, body['x_axis']['labels']['labels'].size
    assert_equal 20, body['elements'][0]['values'].size

    assert_equal '8 - 14 Jun 09', body['x_axis']['labels']['labels'][0]
    assert_equal '', body['x_axis']['labels']['labels'][1]
    assert_equal '', body['x_axis']['labels']['labels'][2]
    assert_equal '', body['x_axis']['labels']['labels'][3]
    assert_equal '6 - 12 Jul 09', body['x_axis']['labels']['labels'][4]
    assert_equal '', body['x_axis']['labels']['labels'][5]
    assert_equal '', body['x_axis']['labels']['labels'][6]
    assert_equal '', body['x_axis']['labels']['labels'][7]
    assert_equal '3 - 9 Aug 09', body['x_axis']['labels']['labels'][8]
    assert_equal '', body['x_axis']['labels']['labels'][9]
    assert_equal '', body['x_axis']['labels']['labels'][10]
    assert_equal '', body['x_axis']['labels']['labels'][11]
    assert_equal '31 Aug - 6 Sep 09', body['x_axis']['labels']['labels'][12]
    assert_equal '', body['x_axis']['labels']['labels'][13]
    assert_equal '', body['x_axis']['labels']['labels'][14]
    assert_equal '', body['x_axis']['labels']['labels'][15]
    assert_equal '28 Sep - 4 Oct 09', body['x_axis']['labels']['labels'][16]
    assert_equal '', body['x_axis']['labels']['labels'][17]
    assert_equal '', body['x_axis']['labels']['labels'][18]
    assert_equal '', body['x_axis']['labels']['labels'][19]

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'months', limit: 10, offset: 0

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal 'Jun 09', body['x_axis']['labels']['labels'][0]
    assert_equal '', body['x_axis']['labels']['labels'][1]
    assert_equal 'Aug 09', body['x_axis']['labels']['labels'][2]
    assert_equal '', body['x_axis']['labels']['labels'][3]
    assert_equal 'Oct 09', body['x_axis']['labels']['labels'][4]
    assert_equal '', body['x_axis']['labels']['labels'][5]
    assert_equal 'Dec 09', body['x_axis']['labels']['labels'][6]
    assert_equal '', body['x_axis']['labels']['labels'][7]
    assert_equal 'Feb 10', body['x_axis']['labels']['labels'][8]
    assert_equal '', body['x_axis']['labels']['labels'][9]

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, offset: 0

    assert_equal 10, body['x_axis']['labels']['labels'].size
    assert_equal 10, body['elements'][0]['values'].size

    assert_equal '03 Mar 10', body['x_axis']['labels']['labels'][0]
    assert_equal '', body['x_axis']['labels']['labels'][1]
    assert_equal '05 Mar 10', body['x_axis']['labels']['labels'][2]
    assert_equal '', body['x_axis']['labels']['labels'][3]
    assert_equal '07 Mar 10', body['x_axis']['labels']['labels'][4]
    assert_equal '', body['x_axis']['labels']['labels'][5]
    assert_equal '09 Mar 10', body['x_axis']['labels']['labels'][6]
    assert_equal '', body['x_axis']['labels']['labels'][7]
    assert_equal '11 Mar 10', body['x_axis']['labels']['labels'][8]
    assert_equal '', body['x_axis']['labels']['labels'][9]
  end

  def test_without_grouping
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, offset: 0

    assert_equal 1, body['elements'].size
    assert_in_delta 9, body['y_axis']['max'], 1
    assert_equal l(:charts_timeline_y), body['y_legend']['text']

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 7, 6, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal get_label(tmp, 2, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 7.4, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(7.4, 2, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    body = get_data project_id: 15_041, project_ids: [15_041, 15_042], range: 'days', limit: 10, offset: 0

    assert_in_delta 14.9, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 14.9 : 15.0

    assert_equal get_label(tmp, 3, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 7.4, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(7.4, 2, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_users
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'user_id', range: 'days', limit: 4, offset: 0

    assert_equal 3, body['elements'].size

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal 'John Smith', body['elements'][1]['text']

    assert_in_delta 3.3, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'Dave Lopper', body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][2]['values'].size
    assert_equal 'redMine Admin', body['elements'][2]['text']

    assert_in_delta 3.3, body['elements'][2]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][2]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][2]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '10 Mar 10'), body['elements'][2]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_priorities
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'priority_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'Normal', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_authors
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'author_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal l(:charts_group_none), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal 'redMine Admin', body['elements'][1]['text']

    assert_in_delta 6.6, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_projects
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, grouping: 'project_id', range: 'days', limit: 4, offset: 0

    assert_equal 1, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal '#15041 Project1', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 7.4, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(7.4, 2, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_statuses
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'status_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'New', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_trackers
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'tracker_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'Bug', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_issues
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'issue_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal '#15045 Issue5', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_versions
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'fixed_version_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal '2.0', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_categories
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'category_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'Category2', body['elements'][0]['text']

    assert_in_delta 6.6, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal l(:charts_group_none), body['elements'][1]['text']

    assert_in_delta 0, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_grouping_by_activities
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, grouping: 'activity_id', range: 'days', limit: 4, offset: 0

    assert_equal 2, body['elements'].size

    assert_equal 4, body['elements'][0]['values'].size
    assert_equal 'Design', body['elements'][0]['text']

    assert_in_delta 3.3, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')

    assert_equal 4, body['elements'][1]['values'].size
    assert_equal 'Development', body['elements'][1]['text']

    assert_in_delta 3.3, body['elements'][1]['values'][0]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][1]['values'][1]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end
  #
  def test_users_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', user_ids: 1, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 4.3, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    assert_equal get_label(tmp, 1, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(2.3, 1, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 3.3, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(0, 0, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_issues_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', issue_ids: 15_045, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_activities_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', activity_ids: 10, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    assert_in_delta 4.3, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(tmp, 1, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 3.3, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(3.3, 1, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 5.1, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(5.1, 1, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_priorities_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', priority_ids: 4, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 7.6, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal get_label(tmp, 2, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(0, 0, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_trackers_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', tracker_ids: 1, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_versions_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, fixed_version_ids: 15_042, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 7.6, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal get_label(tmp, 2, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(0, 0, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][3]['value'], 0.1
    assert_equal get_label(0, 0, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_categories_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', category_ids: 15_042, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 7.6, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal get_label(tmp, 2, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(6.6, 2, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(2.3, 1, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_status_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', status_ids: 2, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 7.6, body['elements'][0]['values'][0]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    assert_equal get_label(tmp, 2, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(0, 0, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_author_condition
    Setting.default_language = 'en'

    body = get_data project_id: 15_041, project_ids: 15_041, range: 'days', author_ids: 2, limit: 10, offset: 0

    assert_equal 10, body['elements'][0]['values'].size
    assert_equal l(:charts_group_all), body['elements'][0]['text']

    assert_in_delta 0, body['elements'][0]['values'][0]['value'], 0.1
    assert_equal get_label(0, 0, '03 Mar 10'), body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][1]['value'], 0.1
    assert_equal get_label(0, 0, '04 Mar 10'), body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 2.3, body['elements'][0]['values'][2]['value'], 0.1
    assert_equal get_label(2.3, 1, '05 Mar 10'), body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 6.6, body['elements'][0]['values'][3]['value'], 0.1

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    assert_equal get_label(tmp, 2, '06 Mar 10'), body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][4]['value'], 0.1
    assert_equal get_label(0, 0, '07 Mar 10'), body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][5]['value'], 0.1
    assert_equal get_label(0, 0, '08 Mar 10'), body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][6]['value'], 0.1
    assert_equal get_label(0, 0, '09 Mar 10'), body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][7]['value'], 0.1
    assert_equal get_label(0, 0, '10 Mar 10'), body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][8]['value'], 0.1
    assert_equal get_label(0, 0, '11 Mar 10'), body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    assert_in_delta 0, body['elements'][0]['values'][9]['value'], 0.1
    assert_equal get_label(0, 0, '12 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
  end

  def test_sub_tasks
    if RedmineCharts.has_sub_issues_functionality_active
      Setting.default_language = 'en'

      body = get_data project_id: 15_044, project_ids: 15_044, range: 'weeks', limit: 10, offset: 0

      assert_equal 10, body['elements'][0]['values'].size
      assert_equal l(:charts_group_all), body['elements'][0]['text']

      assert_in_delta 13.2, body['elements'][0]['values'][9]['value'], 0.1
      assert_equal get_label(13.2, 4, '8 - 14 Mar 10'), body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')
    end
  end

  def test_all_conditions
    Setting.default_language = 'en'
    get_data project_id: 15_041, category_ids: 15_043, tracker_ids: 15_043, fixed_version_ids: 15_043, fixed_version_ids: 15_041, user_ids: 15_043, issue_ids: 15_043, activity_ids: 15_043, author_ids: 1, status_ids: 5
  end

  def get_label(hours, entries, date)
    if hours > 0
      "#{l(:charts_timeline_hint, hours: hours, entries: entries)}<br>#{date}"
    else
      "#{l(:charts_timeline_hint_empty)}<br>#{date}"
    end
  end
end
