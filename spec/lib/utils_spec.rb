require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
  describe Utils do
    before(:all) do
      @utils = RedmineCharts::Utils
    end 

    it "should return default_controller" do
      expect(@utils.default_controller).to eq("charts_burndown")
    end

    it "should return controllers for permissions" do
      expect(@utils.controllers_for_permissions).to eq({:charts_burndown => :index, :charts_burndown2 => :index, :charts_ratio => :index, :charts_timeline => :index, :charts_deviation => :index, :charts_issue => :index})
    end

    it "should return routings" do
      result = []
      @utils.controllers_for_routing do |k,v|
        result << [k, v]
      end
      expect(result).to eq([["burndown", "charts_burndown"], ["burndown2", "charts_burndown2"], ["ratio", "charts_ratio"], ["timeline", "charts_timeline"], ["deviation", "charts_deviation"], ["issue", "charts_issue"]])
    end

    it "should return colors" do
      expect(@utils.colors).to eq([ '#80C31C', '#FF7900', '#DFC329', '#00477F', '#d01f3c', '#356aa0', '#C79810', '#4C88BE', '#5E4725', '#6363AC' ])
      expect(@utils.color(2)).to eq('#DFC329')
    end

    it "should round" do
      expect(@utils.round(0)).to eq(0.0)
      expect(@utils.round(3)).to eq(3.0)
      expect(@utils.round(3.1)).to eq(3.1)
      expect(@utils.round(3.11)).to eq(3.2)
      expect(@utils.round(3.191111)).to eq(3.2)
    end

    it "should get percent" do
      expect(@utils.percent(1,0)).to eq(0)
      expect(@utils.percent(3,10)).to eq(30)
      expect(@utils.percent(3,11)).to eq(27)
    end

  end
end
