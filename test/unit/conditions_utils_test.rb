require File.dirname(__FILE__) + '/../test_helper'

class ConditionsUtilsTest < ActiveSupport::TestCase
  def test_if_return_project_its_subprojects_ids
    assert_equal [15_041, 15_042], RedmineCharts::ConditionsUtils.project_and_its_children_ids(15_041)
  end

  def test_if_return_conditions_types
    assert_equal [:issue_ids, :project_ids, :user_ids, :category_ids, :status_ids, :activity_ids, :fixed_version_ids, :tracker_ids, :priority_ids, :author_ids, :assigned_to_ids], RedmineCharts::ConditionsUtils.types
  end

  def test_if_return_proper_conditions
    types = RedmineCharts::ConditionsUtils.types
    options = RedmineCharts::ConditionsUtils.to_options(types)

    options[:user_ids] = options[:user_ids].select { |u| u[1] != 9 }
    options[:assigned_to_ids] = options[:assigned_to_ids].select { |u| u[1] != 9 }
    options[:author_ids] = options[:author_ids].select { |u| u[1] != 9 }

    assert_equal nil, options[:issue_ids], 'Issue condition'
    assert_equal [['Project1', 15_041], ['Project2', 15_042], ['Project3', 15_043], ['Project4', 15_044]], options[:project_ids], 'Project condition'
    assert_equal [['Anonymous', 6], ['Dave Lopper', 3], ['Dave2 Lopper2', 5], ['John Smith', 2], ['redMine Admin', 1], ['Robert Hill', 4], ['Some One', 7], ['User Misc', 8]], options[:user_ids], 'User condition'
    assert_equal [['Anonymous', 6], ['Dave Lopper', 3], ['Dave2 Lopper2', 5], ['John Smith', 2], ['redMine Admin', 1], ['Robert Hill', 4], ['Some One', 7], ['User Misc', 8]], options[:assigned_to_ids], 'Owner condition'
    assert_equal [['Anonymous', 6], ['Dave Lopper', 3], ['Dave2 Lopper2', 5], ['John Smith', 2], ['redMine Admin', 1], ['Robert Hill', 4], ['Some One', 7], ['User Misc', 8]], options[:author_ids], 'Author condition'
    assert_equal [['Design', 9], ['Development', 10], ['Inactive Activity', 14], ['QA', 11]], options[:activity_ids], 'Activity condition'
    assert_equal [['Project1 - Category1', 15_041], ['Project1 - Category2', 15_042], ['Project2 - Category3', 15_043], ['Project3 - Category4', 15_044], ['Project4 - Category5', 15_045]], options[:category_ids], 'Category condition'
    assert_equal [['Project1 - 1.0', 15_041], ['Project1 - 2.0', 15_042], ['Project4 - 2.0', 15_043]], options[:fixed_version_ids], 'Version condition'
    assert_equal [['Bug', 1], ['Feature request', 2], ['Support request', 3]], options[:tracker_ids], 'Tracker condition'
    assert_equal [['High', 6], ['Immediate', 8], ['Low', 4], ['Normal', 5], ['Urgent', 7]], options[:priority_ids], 'Priority condition'
    assert_equal [['Assigned', 2], ['Closed', 5], ['Feedback', 4], ['New', 1], ['Rejected', 6], ['Resolved', 3]], options[:status_ids], 'Status condition'
  end

  def test_if_set_project_ids_if_not_provided_in_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, {})
    assert_equal [15_041, 15_042], conditions[:project_ids]
  end

  def test_if_set_project_ids_if_provided_empty_project_in_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, project_ids: [])
    assert_equal [15_041, 15_042], conditions[:project_ids]
  end

  def test_if_set_project_ids_if_provided_wrong_in_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, project_ids: [0, nil, 15_041, 15_043, 15_099])
    assert_equal [15_041, 15_043], conditions[:project_ids]
  end

  def test_if_can_read_project_ids_from_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, project_ids: [15_041, 15_042, 15_043])
    assert_equal [15_041, 15_042, 15_043], conditions[:project_ids]
  end

  def test_if_can_read_conditions_from_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, issue_ids: 66, activity_ids: 12)
    assert_equal [66], conditions[:issue_ids]
    assert_equal [12], conditions[:activity_ids]
  end

  def test_if_can_read_multiple_conditions_from_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, category_ids: [3, 5, 7])
    assert_equal [3, 5, 7], conditions[:category_ids]
  end

  def test_if_remove_wrong_conditions_from_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, tracker_ids: [3, 0, nil, 7])
    assert_equal [3, 7], conditions[:tracker_ids]
  end

  def test_if_set_nil_instead_of_empty_array_for_conditions_from_params
    types = RedmineCharts::ConditionsUtils.types
    conditions = RedmineCharts::ConditionsUtils.from_params(types, 15_041, user_ids: 0, issue_ids: nil, author_ids: [0], priority_ids: [nil], status_ids: [])
    assert_nil conditions[:user_ids]
    assert_nil conditions[:issue_ids]
    assert_nil conditions[:author_ids]
    assert_nil conditions[:status_ids]
    assert_nil conditions[:priority_ids]
    assert_nil conditions[:fixed_version_ids]
  end
end
