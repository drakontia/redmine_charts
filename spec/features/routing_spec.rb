require File.dirname(__FILE__) + '/../spec_helper'

describe "Routing", :type => :controller do

  before(:all) do
    @request = ActionController::TestRequest.new
    @request.session[:user_id] = 1

    def routes=(routes)
      @routes = Rails.application.routes
      assertion_instance.instance_variable_set(:@routes, @routes)
    end
  end

  it "should routes to burndown" do
    @controller = ChartsBurndownController.new
    expect(:get => "/projects/Project1/charts/burndown").to route_to(
      :controller => "charts_burndown",
      :action => "index"
    )
  end

  it "should routes to burndown2" do
    @controller = ChartsBurndown2Controller.new
    expect(:get => "/projects/Project1/charts/burndown2").to route_to(
      :controller => "charts_burndown2",
      :action => "index"
    )
  end

  it "should routes to ratio" do
    @controller = ChartsRatioController.new
    expect(:get => "/projects/Project1/charts/ratio").to route_to(
      :controller => "charts_ratio",
      :action => "index"
    )
  end

  it "should routes to timeline" do
    @controller = ChartsTimelineController.new
    expect(:get => "/projects/Project1/charts/timeline").to route_to(
      :controller => "charts_timeline",
      :action => "index"
    )
  end

  it "should routes to deviation" do
    @controller = ChartsDeviationController.new
    expect(:get => "/projects/Project1/charts/deviation").to route_to(
      :controller => "charts_deviation",
      :action => "index"
    )
  end

  it "should routes to Issue" do
    @controller = ChartsIssueController.new
    get("/projects/Project1/charts/issue/index").should route_to("charts_issue#index")
    expect(:get => "/projects/Project1/charts/issue").to route_to(
      :controller => "charts_issue",
      :action => "index"
    )
  end

end
