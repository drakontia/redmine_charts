require File.dirname(__FILE__) + '/../rails_helper'

Rspec.describe 'Routing', type: :routing do

  before(:all) do
    User.current = User.find(1)
  end

  it 'routes /charts/burndown/index to burndown' do
    expect(get: '/projects/Project1/charts/burndown/index').to route_to(
      controller: 'charts_burndown',
      action: 'index'
    )
  end

  it 'routes to burndown2' do
    expect(get: '/projects/Project1/charts/burndown2/index').to route_to(
      controller: 'charts_burndown2',
      action: 'index'
    )
  end

  it 'routes to ratio' do
    expect(get: '/projects/Project1/charts/ratio/index').to route_to(
      controller: 'charts_ratio',
      action: 'index'
    )
  end

  it 'routes to timeline' do
    expect(get: '/projects/Project1/charts/timeline/index').to route_to(
      controller: 'charts_timeline',
      action: 'index'
    )
  end

  it 'routes to deviation' do
    expect(get: '/projects/Project1/charts/deviation/index').to route_to(
      controller: 'charts_deviation',
      action: 'index'
    )
  end

  it 'routes to Issue' do
    expect(get: '/projects/Project1/charts/issue/index').to route_to(
      controller: 'charts_issue',
      action: 'index'
    )
  end

end
