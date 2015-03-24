require File.dirname(__FILE__) + '/../rails_helper'

RSpec.describe ChartsTimelineController, type: :controller do

  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010, 3, 12)
    Setting.default_language = 'en'
    session[:user_id] = 1
  end

  it 'should return data with range weeks offset 0' do
    get :index, project_id: 15_041, project_ids: 15_041, limit: 10, range: 'weeks', offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['x_axis']['min']).to eq(0)
    expect(body['x_axis']['steps']).to eq(1)
    expect(body['x_axis']['max']).to eq(9)
    expect(body['x_axis']['labels']['labels'].size).to eq(10)
    expect(body['elements'][0]['values'].size).to eq(10)

    expect(body['x_axis']['labels']['labels'][0]).to eq('4 - 10 Jan 10')
    expect(body['x_axis']['labels']['labels'][1]).to eq('')
    expect(body['x_axis']['labels']['labels'][2]).to eq('18 - 24 Jan 10')
    expect(body['x_axis']['labels']['labels'][3]).to eq('')
    expect(body['x_axis']['labels']['labels'][4]).to eq('1 - 7 Feb 10')
    expect(body['x_axis']['labels']['labels'][5]).to eq('')
    expect(body['x_axis']['labels']['labels'][6]).to eq('15 - 21 Feb 10')
    expect(body['x_axis']['labels']['labels'][7]).to eq('')
    expect(body['x_axis']['labels']['labels'][8]).to eq('1 - 7 Mar 10')
    expect(body['x_axis']['labels']['labels'][9]).to eq('')
  end

  it 'should return data with range weeks offset 10' do
    get :index, project_id: 15_041, project_ids: 15_041, offset: 10, limit: 10, range: 'weeks'
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['x_axis']['labels']['labels'].size).to eq(10)
    expect(body['elements'][0]['values'].size).to eq(10)

    expect(body['x_axis']['labels']['labels'][0]).to eq('26 Oct - 1 Nov 09')
    expect(body['x_axis']['labels']['labels'][1]).to eq('')
    expect(body['x_axis']['labels']['labels'][2]).to eq('9 - 15 Nov 09')
    expect(body['x_axis']['labels']['labels'][3]).to eq('')
    expect(body['x_axis']['labels']['labels'][4]).to eq('23 - 29 Nov 09')
    expect(body['x_axis']['labels']['labels'][5]).to eq('')
    expect(body['x_axis']['labels']['labels'][6]).to eq('7 - 13 Dec 09')
    expect(body['x_axis']['labels']['labels'][7]).to eq('')
    expect(body['x_axis']['labels']['labels'][8]).to eq('21 - 27 Dec 09')
    expect(body['x_axis']['labels']['labels'][9]).to eq('')
  end

  it 'should return data with range weeks offset 20' do
    get :index, project_id: 15_041, project_ids: 15_041, offset: 20, limit: 20, range: 'weeks'
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['x_axis']['labels']['labels'].size).to eq(20)
    expect(body['elements'][0]['values'].size).to eq(20)

    expect(body['x_axis']['labels']['labels'][0]).to eq('8 - 14 Jun 09')
    expect(body['x_axis']['labels']['labels'][1]).to eq('')
    expect(body['x_axis']['labels']['labels'][2]).to eq('')
    expect(body['x_axis']['labels']['labels'][3]).to eq('')
    expect(body['x_axis']['labels']['labels'][4]).to eq('6 - 12 Jul 09')
    expect(body['x_axis']['labels']['labels'][5]).to eq('')
    expect(body['x_axis']['labels']['labels'][6]).to eq('')
    expect(body['x_axis']['labels']['labels'][7]).to eq('')
    expect(body['x_axis']['labels']['labels'][8]).to eq('3 - 9 Aug 09')
    expect(body['x_axis']['labels']['labels'][9]).to eq('')
    expect(body['x_axis']['labels']['labels'][10]).to eq('')
    expect(body['x_axis']['labels']['labels'][11]).to eq('')
    expect(body['x_axis']['labels']['labels'][12]).to eq('31 Aug - 6 Sep 09')
    expect(body['x_axis']['labels']['labels'][13]).to eq('')
    expect(body['x_axis']['labels']['labels'][14]).to eq('')
    expect(body['x_axis']['labels']['labels'][15]).to eq('')
    expect(body['x_axis']['labels']['labels'][16]).to eq('28 Sep - 4 Oct 09')
    expect(body['x_axis']['labels']['labels'][17]).to eq('')
    expect(body['x_axis']['labels']['labels'][18]).to eq('')
    expect(body['x_axis']['labels']['labels'][19]).to eq('')
  end

  it 'should return data with range months with offset 0' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'months', limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['x_axis']['labels']['labels'].size).to eq(10)
    expect(body['elements'][0]['values'].size).to eq(10)

    expect(body['x_axis']['labels']['labels'][0]).to eq('Jun 09')
    expect(body['x_axis']['labels']['labels'][1]).to eq('')
    expect(body['x_axis']['labels']['labels'][2]).to eq('Aug 09')
    expect(body['x_axis']['labels']['labels'][3]).to eq('')
    expect(body['x_axis']['labels']['labels'][4]).to eq('Oct 09')
    expect(body['x_axis']['labels']['labels'][5]).to eq('')
    expect(body['x_axis']['labels']['labels'][6]).to eq('Dec 09')
    expect(body['x_axis']['labels']['labels'][7]).to eq('')
    expect(body['x_axis']['labels']['labels'][8]).to eq('Feb 10')
    expect(body['x_axis']['labels']['labels'][9]).to eq('')
  end

  it 'should return data with range days with offset 0' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['x_axis']['labels']['labels'].size).to eq(10)
    expect(body['elements'][0]['values'].size).to eq(10)

    expect(body['x_axis']['labels']['labels'][0]).to eq('03 Mar 10')
    expect(body['x_axis']['labels']['labels'][1]).to eq('')
    expect(body['x_axis']['labels']['labels'][2]).to eq('05 Mar 10')
    expect(body['x_axis']['labels']['labels'][3]).to eq('')
    expect(body['x_axis']['labels']['labels'][4]).to eq('07 Mar 10')
    expect(body['x_axis']['labels']['labels'][5]).to eq('')
    expect(body['x_axis']['labels']['labels'][6]).to eq('09 Mar 10')
    expect(body['x_axis']['labels']['labels'][7]).to eq('')
    expect(body['x_axis']['labels']['labels'][8]).to eq('11 Mar 10')
    expect(body['x_axis']['labels']['labels'][9]).to eq('')
  end

  it 'should return data without grouping' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(1)
    expect(body['y_axis']['max']).to be_within(1).of(9)
    expect(body['y_legend']['text']).to eq(l(:charts_timeline_y))

    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(7.4)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(7.4, 2, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with range days with offset 0' do
    get :index, project_id: 15_041, project_ids: [15_041, 15_042], range: 'days', limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(14.9)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 14.9 : 15.0

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 3, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(7.4)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(7.4, 2, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with grouping by users' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'user_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(3)

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq('John Smith')

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('Dave Lopper')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))

    expect(body['elements'][2]['values'].size).to eq(4)
    expect(body['elements'][2]['text']).to eq('Redmine Admin')

    expect(body['elements'][2]['values'][0]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][2]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][2]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][2]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '10 Mar 10'))
  end

  it 'should return data with grouping_by_priorities' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'priority_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('High')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_authors' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'author_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('Redmine Admin')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_projects' do
    get :index, project_id: 15_041, grouping: 'project_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(1)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('#15041 Project1')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(7.4)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(7.4, 2, '10 Mar 10'))
  end

  it 'should return data with grouping_by_statuses' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'status_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('New')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_trackers' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'tracker_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('Bug')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_issues' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'issue_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('#15045 Issue5')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_versions' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'fixed_version_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('2.0')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_categories' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'category_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('Category2')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq(l(:charts_group_none))

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with grouping_by_activities' do
    get :index, project_id: 15_041, project_ids: 15_041, grouping: 'activity_id', range: 'days', limit: 4, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'].size).to eq(2)

    expect(body['elements'][0]['values'].size).to eq(4)
    expect(body['elements'][0]['text']).to eq('Design')

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))

    expect(body['elements'][1]['values'].size).to eq(4)
    expect(body['elements'][1]['text']).to eq('Development')

    expect(body['elements'][1]['values'][0]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][1]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][1]['values'][1]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][1]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
  end

  it 'should return data with users_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', user_ids: 1, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(4.3)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 1, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with issues_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', issue_ids: 15_045, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", ''))    .to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with activities_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', activity_ids: 9, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(4.3)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 1, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(3.3)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(3.3, 1, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(5.1)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(5.1, 1, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with priorities_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', priority_ids: 4, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with trackers_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', tracker_ids: 1, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with versions_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', limit: 10, fixed_version_ids: 15_042, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with categories_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', category_ids: 15_042, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(6.6)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(6.6, 2, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with status_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', status_ids: 2, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with author_condition' do
    get :index, project_id: 15_041, project_ids: 15_041, range: 'days', author_ids: 2, limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

    body = ActiveSupport::JSON.decode(assigns[:data])
    expect(body['elements'][0]['values'].size).to eq(10)
    expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

    expect(body['elements'][0]['values'][0]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][0]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '03 Mar 10'))
    expect(body['elements'][0]['values'][1]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][1]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '04 Mar 10'))
    expect(body['elements'][0]['values'][2]['value']).to be_within(0.1).of(2.3)
    expect(body['elements'][0]['values'][2]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(2.3, 1, '05 Mar 10'))
    expect(body['elements'][0]['values'][3]['value']).to be_within(0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    expect(body['elements'][0]['values'][3]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(tmp, 2, '06 Mar 10'))
    expect(body['elements'][0]['values'][4]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][4]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '07 Mar 10'))
    expect(body['elements'][0]['values'][5]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][5]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '08 Mar 10'))
    expect(body['elements'][0]['values'][6]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][6]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '09 Mar 10'))
    expect(body['elements'][0]['values'][7]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][7]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '10 Mar 10'))
    expect(body['elements'][0]['values'][8]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][8]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '11 Mar 10'))
    expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(0)
    expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(0, 0, '12 Mar 10'))
  end

  it 'should return data with sub_tasks' do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, project_id: 15_044, project_ids: 15_044, range: 'weeks', limit: 10, offset: 0
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  skip 'not DRY yet' do

      body = ActiveSupport::JSON.decode(assigns[:data])
      expect(body['elements'][0]['values'].size).to eq(10)
      expect(body['elements'][0]['text']).to eq(l(:charts_group_all))

      expect(body['elements'][0]['values'][9]['value']).to be_within(0.1).of(13.2)
      expect(body['elements'][0]['values'][9]['tip'].gsub('\\u003C', '<').gsub('\\u003E', '>').gsub("\000", '')).to eq(get_label(13.2, 4, '8 - 14 Mar 10'))
    end
  end

  it 'should return data with all_conditions' do
    get :index, project_id: 15_041, category_ids: 15_043, tracker_ids: 15_043, fixed_version_ids: 15_043, fixed_version_ids: 15_041, user_ids: 15_043, issue_ids: 15_043, activity_ids: 15_043, author_ids: 1, status_ids: 5
    expect(response).to be_success
    expect(assigns[:data]).to be_truthy
  end

  def get_label(hours, entries, date)
    if hours > 0
      "#{l(:charts_timeline_hint, hours: hours, entries: entries)}<br>#{date}"
    else
      "#{l(:charts_timeline_hint_empty)}<br>#{date}"
    end
  end

end
