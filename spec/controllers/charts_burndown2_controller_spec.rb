require File.dirname(__FILE__) + '/../rails_helper'

Rspec.describe ChartsBurndown2Controller, type: :controller do

  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010, 4, 16)
    session[:user_id] = 1
    Setting.default_language = 'en'
  end

  it 'should return data with grouping by fixed version' do
    get :index, project_id: 15_041, fixed_version_ids: [15_042]
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do
    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['y_legend']['text']).to eq(l(:charts_burndown2_y))
    expect(body['x_legend']['text']).to eq(l(:charts_burndown2_x))
    expect(body['y_axis']['max']).to be_within(1).of(24)
    expect(body['y_axis']['min']).to eq(0)
    expect(body['x_axis']['max']).to be_within(1).of(42)
    expect(body['x_axis']['min']).to eq(0)
    expect(body['x_axis']['labels']['labels'].size).to eq(43)
    expect(body['x_axis']['labels']['labels'][0]).to eq('20 Mar 10')
    expect(body['x_axis']['labels']['labels'][40]).to eq('29 Apr 10')

    expect(body['elements'].size).to eq(2)
    expect(body['elements'][0]['values'].size).to eq(43)
    expect(body['elements'][0]['text']).to eq(l(:charts_burndown2_group_velocity))
    expect(body['elements'][1]['values'].size).to eq(28)
    expect(body['elements'][1]['text']).to eq(l(:charts_burndown2_group_burndown))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(20)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown2_hint_velocity, remaining_hours: 20.0)}<br>#{'20 Mar 10'}")
    expect(body['elements'][0]['values'][20]['value']).to be_within(0.1).of(10.7)
    expect(body['elements'][0]['values'][20]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown2_hint_velocity, remaining_hours: 10.7)}<br>#{'09 Apr 10'}")
    expect(body['elements'][0]['values'][42]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][42]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown2_hint_velocity, remaining_hours: 0.0)}<br>#{'01 May 10'}")

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(11.0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 60)}<br>#{'20 Mar 10'}")
    expect(body['elements'][1]['values'][27]['value']).to be_within(0.1).of(11.0)
    expect(body['elements'][1]['values'][27]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown_hint_remaining, remaining_hours: 11.0, work_done: 60)}<br>#{'16 Apr 10'}")
    expect(body['elements'][1]['values'][28]).to be_nil

  end

  it 'should return data if it has sub tasks' do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, project_id: 15_044, fixed_version_ids: [15_043]
      expect(response).to be_success
      expect(assigns[:data]).to be_truthy
    end
  end

  skip 'not DRY yet' do
    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(12)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown2_hint_velocity, remaining_hours: 12.0)}<br>#{'20 Mar 10'}")

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(12.0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq("#{l(:charts_burndown_hint_remaining, remaining_hours: 12.0, work_done: 0)}<br>#{'20 Mar 10'}")
  end

end
