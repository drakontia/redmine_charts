require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsIssueController do

  include Redmine::I18n

  before do
    @controller = ChartsIssueController.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1
    Setting.default_language = 'en'
  end

  it 'should return data with grouping issue_id' do
    get :index, project_id: 15_041, project_ids: [15_041, 15_042]
    expect(response).to be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(3)

    expect(body['elements'][0]['values'][0]['label']).to eq('New')
    expect(body['elements'][0]['values'][0]['value']).to be_within(1).of(1)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_issue_hint, label: 'New', issues: 1, percent: 20, total_issues: 5)}")

    expect(body['elements'][0]['values'][1]['label']).to eq('Assigned')
    expect(body['elements'][0]['values'][1]['value']).to be_within(1).of(3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_issue_hint, label: 'Assigned', issues: 3, percent: 60, total_issues: 5)}")

    expect(body['elements'][0]['values'][2]['label']).to eq('Resolved')
    expect(body['elements'][0]['values'][2]['value']).to be_within(1).of(1)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_issue_hint, label: 'Resolved', issues: 1, percent: 20, total_issues: 5)}")

  end

  it 'should return data with grouping issue_id if it has sub tasks' do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, project_id: 15_044, project_ids: [15_044]
      expect(response).to be_success

      body = ActiveSupport::JSON.decode(assigns[:data])
      expect(body['elements'][0]['values'].size).to eq(1)

      expect(body['elements'][0]['values'][0]['label']).to eq('Resolved')
      expect(body['elements'][0]['values'][0]['value']).to be_within(1).of(4)
      expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_issue_hint, label: 'Resolved', issues: 4, percent: 100, total_issues: 4)}")

    end
  end

end
