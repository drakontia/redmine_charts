require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/charts_controller_test'
require 'charts_ratio_controller'

class ChartsRatioController
  def rescue_action(e)
    fail e
  end

  def authorize
    true
  end

  attr_reader :saved_conditions

  attr_reader :saved_condition
end

class SavedConditionsTest < ActionController::TestCase
  include Redmine::I18n

  def setup
    @controller = ChartsRatioController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    User.current = nil
  end

  def test_if_return_saved_conditions
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    get :index, project_id: 15_041
    assert_response :success

    assert_equal 1, @controller.saved_conditions.size
  end

  def test_if_return_saved_conditions_for_all_projects
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: nil)
    c.conditions = { a: 'b' }
    c.save

    get :index, project_id: 15_041
    assert_response :success

    assert_equal 1, @controller.saved_conditions.size
  end

  def test_if_not_return_saved_conditions_for_other_project
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_042)
    c.conditions = { a: 'b' }
    c.save

    get :index, project_id: 15_041
    assert_response :success

    assert_equal 0, @controller.saved_conditions.size
  end

  def test_if_destroy_saved_condition
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    assert_equal 1, ChartSavedCondition.all.size

    get :destroy_saved_condition, project_id: 15_041, id: c.id
    assert_response :redirect

    assert_equal 0, ChartSavedCondition.all.size

    assert_equal l(:charts_saved_condition_flash_deleted), flash[:notice]
  end

  def test_if_return_error_when_try_destroy_not_existed_saved_conditions
    ChartSavedCondition.destroy_all

    get :destroy_saved_condition, project_id: 15_041, id: 1
    assert_response :redirect

    assert_equal l(:charts_saved_condition_flash_not_found), flash[:error]
  end

  def test_if_create_saved_conditions
    ChartSavedCondition.destroy_all

    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: 'Test', saved_condition_create_project_id: 15_041, project_ids: [15_041], grouping: :activity_id, priority_ids: [5, 6]
    assert_response :success

    condition = ChartSavedCondition.first

    assert_not_nil condition
    assert_equal 'Test', condition.name
    assert_equal 'ratio', condition.chart
    assert_equal 15_041, condition.project_id
    conditions = condition.conditions.split('&')
    assert_equal 4, conditions.size
    assert conditions.include?('grouping=activity_id')
    assert conditions.include?('priority_ids[]=5')
    assert conditions.include?('priority_ids[]=6')
    assert conditions.include?('project_ids[]=15041')
    assert_equal l(:charts_saved_condition_flash_created), flash[:notice]
  end

  def test_if_return_error_for_blank_name
    ChartSavedCondition.destroy_all

    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: '', saved_condition_create_project_id: 15_041
    assert_response :success

    assert_equal l(:charts_saved_condition_flash_name_cannot_be_blank), flash[:error]
  end

  def test_if_return_error_for_duplicated_name
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: 'Test', saved_condition_create_project_id: 15_041
    assert_response :success

    assert_equal l(:charts_saved_condition_flash_name_exists), flash[:error]
  end

  def test_if_update_saved_conditions
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Old test', chart: 'old_ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    get :index, project_id: 15_041, chart_form_action: 'saved_condition_update', saved_condition_update_name: 'Test', saved_condition_update_project_id: nil, saved_condition_id: c.id, project_ids: [15_041], grouping: :activity_id, priority_ids: [5, 6]
    assert_response :success

    condition = ChartSavedCondition.first

    assert_not_nil condition
    assert_equal 'Test', condition.name
    assert_equal 'ratio', condition.chart
    assert_nil condition.project_id

    conditions = condition.conditions.split('&')
    assert_equal 4, conditions.size
    assert conditions.include?('grouping=activity_id')
    assert conditions.include?('priority_ids[]=5')
    assert conditions.include?('priority_ids[]=6')
    assert conditions.include?('project_ids[]=15041')

    assert_equal l(:charts_saved_condition_flash_updated), flash[:notice]
  end
end
