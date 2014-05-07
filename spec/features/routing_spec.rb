require File.dirname(__FILE__) + '/../spec_helper'

describe "Routing", :type => :controller do

  before(:all) do
    @request = ActionController::TestRequest.new
    @request.session[:user_id] = 1
  end

  it "should routes to burndown" do
    expect(:get => "/projects/charts_project1/charts/burndown/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_burndown",
      :action => "index"
    )
  end

  it "should routes to burndown2" do
    expect(:get => "/projects/charts_project1/charts/burndown2/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_burndown2",
      :action => "index"
    )
  end

  it "should routes to ratio" do
    expect(:get => "/projects/charts_project1/charts/ratio/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_ratio",
      :action => "index"
    )
  end

  it "should routes to timeline" do
    expect(:get => "/projects/charts_project1/charts/timeline/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_timeline",
      :action => "index"
    )
  end

  it "should routes to deviation" do
    expect(:get => "/projects/charts_project1/charts/deviation/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_deviation",
      :action => "index"
    )
  end

  it "should routes to Issue" do
    expect(:get => "/projects/charts_project1/charts/issue/index").to route_to(
      :project_id => "charts_project1",
      :controller => "charts_issue",
      :action => "index"
    )
  end

end
