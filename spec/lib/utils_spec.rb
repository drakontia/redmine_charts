require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
  describe Utils do
    before(:all) do
      @utils = RedmineCharts::Utils
    end

    it "should return default_controller" do
      @utils.default_controller.should == "charts_burndown"
    end

    it "should return controllers for permissions" do
      @utils.controllers_for_permissions.should == {
        :charts_burndown => :index,
        :charts_burndown2 => :index,
        :charts_ratio => :index,
        :charts_timeline => :index,
        :charts_deviation => :index,
        :charts_issue => :index
      }
    end

    it "should return routings" do
      result = []
      @utils.controllers_for_routing do |k,v|
        result << [k, v]
      end
      result.should == [["burndown", "charts_burndown"], ["burndown2", "charts_burndown2"], ["ratio", "charts_ratio"], ["timeline", "charts_timeline"], ["deviation", "charts_deviation"], ["issue", "charts_issue"]]
    end

    it "should return colors" do
      @utils.colors.should == [ '#80C31C', '#FF7900', '#DFC329', '#00477F', '#d01f3c', '#356aa0', '#C79810', '#4C88BE', '#5E4725', '#6363AC' ]
      @utils.color(2).should == '#DFC329'
    end

    it "should round" do
      @utils.round(0).should == 0.0
      @utils.round(3).should == 3.0
      @utils.round(3.1).should == 3.1
      @utils.round(3.11).should == 3.2
      @utils.round(3.191111).should == 3.2
    end

    it "should get percent" do
      @utils.percent(1,0).should == 0
      @utils.percent(3,10).should == 30
      @utils.percent(3,11).should == 27
    end

  end
end
