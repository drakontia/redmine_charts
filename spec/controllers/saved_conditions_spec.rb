require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsRatioController do

  include Redmine::I18n

  before do
    @controller = ChartsRatioController.new
  end

  it 'should return_saved_conditions' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    @request.session[:user_id] = 1
    get :index, project_id: 15_041
    expect(response).to be_success

    expect(assigns[:saved_conditions].size).to eq(1)
  end

  it 'should return_saved_conditions_for_all_projects' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: nil)
    c.conditions = { a: 'b' }
    c.save

    @request.session[:user_id] = 1
    get :index, project_id: 15_041
    expect(response).to be_success

    expect(assigns[:saved_conditions].size).to eq(1)
  end

  it 'should not_return_saved_conditions_for_other_project' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_042)
    c.conditions = { a: 'b' }
    c.save

    @request.session[:user_id] = 1
    get :index, project_id: 15_041
    expect(response).to be_success

    expect(assigns[:saved_conditions].size).to eq(0)
  end

  it 'should destroy_saved_condition' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    expect(ChartSavedCondition.all.size).to eq(1)

    @request.session[:user_id] = 1
    get :destroy_saved_condition, project_id: 15_041, id: c.id
    expect(response).not_to be_success

    expect(ChartSavedCondition.all.size).to eq(0)

    expect(flash[:notice]).to eq(l(:charts_saved_condition_flash_deleted))
  end

  it 'should return_error_when_try_destroy_not_existed_saved_conditions' do
    ChartSavedCondition.destroy_all

    @request.session[:user_id] = 1
    get :destroy_saved_condition, project_id: 15_041, id: 1
    expect(response).not_to be_success

    expect(flash[:error]).to eq(l(:charts_saved_condition_flash_not_found))
  end

  it 'should create_saved_conditions' do
    ChartSavedCondition.destroy_all

    @request.session[:user_id] = 1
    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: 'Test', saved_condition_create_project_id: 15_041, project_ids: [15_041], grouping: :activity_id, priority_ids: [5, 6]
    expect(response).to be_success

    condition = ChartSavedCondition.first

    expect(condition).not_to be_nil
    expect(condition.name).to eq('Test')
    expect(condition.chart).to eq('ratio')
    expect(condition.project_id).to eq(15_041)
    conditions = condition.conditions.split('&')
    expect(conditions.size).to eq(4)
    expect(conditions).to include('grouping=activity_id')
    expect(conditions).to include('priority_ids[]=5')
    expect(conditions).to include('priority_ids[]=6')
    expect(conditions).to include('project_ids[]=15041')
    expect(flash[:notice]).to eq(l(:charts_saved_condition_flash_created))
  end

  it 'should return_error_for_blank_name' do
    ChartSavedCondition.destroy_all

    @request.session[:user_id] = 1
    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: '', saved_condition_create_project_id: 15_041
    expect(response).to be_success

    expect(flash[:error]).to eq(l(:charts_saved_condition_flash_name_cannot_be_blank))
  end

  it 'should return_error_for_duplicated_name' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Test', chart: 'ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    @request.session[:user_id] = 1
    get :index, project_id: 15_041, chart_form_action: 'saved_condition_create', saved_condition_create_name: 'Test', saved_condition_create_project_id: 15_041
    expect(response).to be_success

    expect(flash[:error]).to eq(l(:charts_saved_condition_flash_name_exists))
  end

  it 'should update_saved_conditions' do
    ChartSavedCondition.destroy_all

    c = ChartSavedCondition.new(name: 'Old test', chart: 'old_ratio', project_id: 15_041)
    c.conditions = { a: 'b' }
    c.save

    @request.session[:user_id] = 1
    get :index, project_id: 15_041, chart_form_action: 'saved_condition_update', saved_condition_update_name: 'Test', saved_condition_update_project_id: nil, saved_condition_id: c.id, project_ids: [15_041], grouping: :activity_id, priority_ids: [5, 6]
    expect(response).to be_success

    condition = ChartSavedCondition.first

    expect(condition).not_to be_nil
    expect(condition.name).to eq('Test')
    expect(condition.chart).to eq('ratio')
    expect(condition.project_id).to be_nil

    conditions = condition.conditions.split('&')
    expect(conditions.size).to eq(4)
    expect(conditions).to include('grouping=activity_id')
    expect(conditions).to include('priority_ids[]=5')
    expect(conditions).to include('priority_ids[]=6')
    expect(conditions).to include('project_ids[]=15041')

    expect(flash[:notice]).to eq(l(:charts_saved_condition_flash_updated))
  end

end
