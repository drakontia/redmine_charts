require File.dirname(__FILE__) + '/../test_helper'

class GroupingUtilsTest < ActiveSupport::TestCase
  def test_if_return_grouping_types
    assert_equal [:user_id, :issue_id, :activity_id, :category_id, :tracker_id, :fixed_version_id, :priority_id, :author_id, :status_id, :project_id, :assigned_to_id], RedmineCharts::GroupingUtils.types
  end

  def test_if_return_all_for_nil_or_none_grouping
    assert_equal 'all', RedmineCharts::GroupingUtils.to_string(nil, nil)
    assert_equal 'all', RedmineCharts::GroupingUtils.to_string(4, :none)
    assert_equal 'all', RedmineCharts::GroupingUtils.to_string(nil, nil, 'default')
    assert_equal 'all', RedmineCharts::GroupingUtils.to_string(4, :none, 'default')
  end

  def test_if_return_none_for_not_existed_grouping
    assert_equal 'none', RedmineCharts::GroupingUtils.to_string(3, :other)
  end

  def test_if_return_default_if_provided
    assert_equal 'default', RedmineCharts::GroupingUtils.to_string(3, :other, 'default')
  end

  def test_if_return_string_representation_of_users_grouping
    assert_equal 'John Smith', RedmineCharts::GroupingUtils.to_string(2, :user_id)
    assert_equal 'none', RedmineCharts::GroupingUtils.to_string(0, :user_id)
    assert_equal 'Ozzy', RedmineCharts::GroupingUtils.to_string(666, :user_id, 'Ozzy')
  end

  def test_if_return_string_representation_of_issues_grouping
    assert_equal '#15042 Issue2', RedmineCharts::GroupingUtils.to_string(15_042, :issue_id)
  end

  def test_if_return_string_representation_of_activities_grouping
    assert_equal 'Design', RedmineCharts::GroupingUtils.to_string(9, :activity_id)
  end

  def test_if_return_string_representation_of_categories_grouping
    assert_equal 'Category2', RedmineCharts::GroupingUtils.to_string(15_042, :category_id)
  end

  def test_if_return_string_representation_of_trackers_grouping
    assert_equal 'Bug', RedmineCharts::GroupingUtils.to_string(1, :tracker_id)
  end

  def test_if_return_string_representation_of_versions_grouping
    assert_equal '2.0', RedmineCharts::GroupingUtils.to_string(15_042, :fixed_version_id)
  end

  def test_if_return_string_representation_of_priorities_grouping
    assert_equal 'Normal', RedmineCharts::GroupingUtils.to_string(5, :priority_id)
  end

  def test_if_return_string_representation_of_authors_grouping
    assert_equal 'Dave Lopper', RedmineCharts::GroupingUtils.to_string(3, :author_id)
  end

  def test_if_return_string_representation_of_owners_grouping
    assert_equal 'Dave Lopper', RedmineCharts::GroupingUtils.to_string(3, :assigned_to_id)
  end

  def test_if_return_string_representation_of_statuses_grouping
    assert_equal 'Assigned', RedmineCharts::GroupingUtils.to_string(2, :status_id)
  end

  def test_if_return_string_representation_of_projects_grouping
    assert_equal '#15042 Project2', RedmineCharts::GroupingUtils.to_string(15_042, :project_id)
  end

  def test_if_return_nil_when_param_does_not_include_grouping
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, {})
    assert_equal nil, grouping
  end

  def test_if_return_nil_when_param_include_wrong_grouping
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, grouping: :other)
    assert_equal nil, grouping
  end

  def test_if_return_proper_grouping_from_params
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, grouping: :user_id)
    assert_equal :user_id, grouping
  end

  def test_if_return_proper_grouping_from_string_params
    types = RedmineCharts::GroupingUtils.types
    grouping = RedmineCharts::GroupingUtils.from_params(types, grouping: 'tracker_id')
    assert_equal :tracker_id, grouping
  end
end
