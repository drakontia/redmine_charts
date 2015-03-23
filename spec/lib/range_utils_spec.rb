require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
describe RangeUtils do

  before do
    Time.set_current_date = Time.mktime(2010,3,3)
    @utils = RedmineCharts::RangeUtils
  end

  it "should return_range_types" do
    expect(@utils.types).to eq([ :months, :weeks, :days ])
  end

  it "should set_range_if_not_provided_in_params" do
    expect(@utils.from_params({})).to be_nil
  end

  it "should read_range_type_from_params" do
    expect(@utils.from_params({ :range => "days" })).to be_nil
  end

  it "should read_range_offset_from_params" do
    expect(@utils.from_params({ :offset => "1" })).to be_nil
  end

  it "should read_range_limit_from_params" do
    expect(@utils.from_params({ :limit => "11" })).to be_nil
  end

  it "should read_range_from_params" do
    range = @utils.from_params({ :offset => "2", :range => "months", :limit => "11" })
    expect(range[:range]).to eq(:months)
    expect(range[:offset]).to eq(2)
    expect(range[:limit]).to eq(11)
  end

  it "should propose_range_for_today" do
    range = @utils.propose_range({ :week => "2010009", :month => "201003", :day => "2010062" })
    expect(range[:range]).to eq(:days)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(11)
  end

  it "should propose_range_for_10_days_ago" do
    range = @utils.propose_range({ :week => "2010008", :month => "2010003", :day => "2010052" })
    expect(range[:range]).to eq(:days)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(11)
  end

  it "should propose_range_for_20_days_ago" do
    range = @utils.propose_range({ :week => "2010007", :month => "2010003", :day => "2010042" })
    expect(range[:range]).to eq(:days)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(21)
  end

  it "should propose_range_for_21_days_ago" do
    range = @utils.propose_range({ :week => "2010006", :month => "2010003", :day => "2010041" })
    expect(range[:range]).to eq(:weeks)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(11)
  end

  it "should propose_range_for_20_weeks_ago" do
    range = @utils.propose_range({ :week => "2009042", :month => "2009011", :day => "2009300" })
    expect(range[:range]).to eq(:weeks)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(21)
  end

  it "should propose_range_for_21_weeks_ago" do
    range = @utils.propose_range({ :week => "2009040", :month => "2009011", :day => "2009300" })
    expect(range[:range]).to eq(:months)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(11)
  end

  it "should propose_range_for_21_months_ago" do
    range = @utils.propose_range({ :week => "2009039", :month => "2008001", :day => "2009300" })
    expect(range[:range]).to eq(:months)
    expect(range[:offset]).to eq(0)
    expect(range[:limit]).to eq(27)
  end

  it "should prepare_range_for_days" do
    range = @utils.prepare_range({ :range => :days, :limit => 10, :offset => 0 })
    expect(range[:range]).to eq(:days)
    expect(range[:keys].size).to eq(10)
    expect(range[:keys][0]).to eq("2010053")
    expect(range[:keys][1]).to eq("2010054")
    expect(range[:keys][2]).to eq("2010055")
    expect(range[:keys][3]).to eq("2010056")
    expect(range[:keys][4]).to eq("2010057")
    expect(range[:keys][5]).to eq("2010058")
    expect(range[:keys][6]).to eq("2010059")
    expect(range[:keys][7]).to eq("2010060")
    expect(range[:keys][8]).to eq("2010061")
    expect(range[:keys][9]).to eq("2010062")
    expect(range[:min]).to eq("2010053")
    expect(range[:max]).to eq("2010062")
    expect(range[:labels].size).to eq(10)
    expect(range[:labels][0]).to eq("22 Feb 10")
    expect(range[:labels][1]).to eq("23 Feb 10")
    expect(range[:labels][2]).to eq("24 Feb 10")
    expect(range[:labels][3]).to eq("25 Feb 10")
    expect(range[:labels][4]).to eq("26 Feb 10")
    expect(range[:labels][5]).to eq("27 Feb 10")
    expect(range[:labels][6]).to eq("28 Feb 10")
    expect(range[:labels][7]).to eq("01 Mar 10")
    expect(range[:labels][8]).to eq("02 Mar 10")
    expect(range[:labels][9]).to eq("03 Mar 10")

  end

  it "should prepare_range_for_days_with_offset" do
    range = @utils.prepare_range({ :range => :days, :limit => 10, :offset => 5 })
    expect(range[:range]).to eq(:days)
    expect(range[:min]).to eq("2010048")
    expect(range[:max]).to eq("2010057")
  end

  it "should prepare_range_for_days_with_year_difference" do
    range = @utils.prepare_range({ :range => :days, :limit => 60, :offset => 5 })
    expect(range[:range]).to eq(:days)
    expect(range[:min]).to eq("2009363") # 2009-12-29
    expect(range[:max]).to eq("2010057")
    expect(range[:keys][1]).to eq("2009364") # 2009-12-30
    expect(range[:keys][2]).to eq("2009365") # 2009-12-31
    expect(range[:keys][3]).to eq("2010001")
  end


  it "should prepare_range_for_weeks" do
    range = @utils.prepare_range({ :range => :weeks, :limit => 5, :offset => 0 })
    expect(range[:range]).to eq(:weeks)
    expect(range[:min]).to eq("2010005")
    expect(range[:max]).to eq("2010009")
  end

  it "should prepare_range_for_weeks_with_offset" do
    range = @utils.prepare_range({ :range => :weeks, :limit => 5, :offset => 1 })
    expect(range[:range]).to eq(:weeks)
    expect(range[:min]).to eq("2010004")
    expect(range[:max]).to eq("2010008")
  end

  it "should prepare_range_for_weeks_with_year_difference" do
    range = @utils.prepare_range({ :range => :weeks, :limit => 15, :offset => 1 })
    expect(range[:range]).to eq(:weeks)
    expect(range[:min]).to eq("2009046") # 2009-11-18
    expect(range[:max]).to eq("2010008")
    expect(range[:keys].size).to eq(15)
    expect(range[:keys][0]).to eq("2009046") # 2009-11-18
    expect(range[:keys][4]).to eq("2009050") # 2009-12-16
    expect(range[:keys][5]).to eq("2009051") # 2009-12-23
    expect(range[:keys][6]).to eq("2009052") # 2009-12-30
    expect(range[:keys][7]).to eq("2010001")
    expect(range[:keys][14]).to eq("2010008")
    expect(range[:labels].size).to eq(15)
    expect(range[:labels][2]).to eq("30 Nov - 6 Dec 09")
    expect(range[:labels][5]).to eq("21 - 27 Dec 09")
    expect(range[:labels][6]).to eq("28 Dec 09 - 3 Jan 10")
    expect(range[:labels][7]).to eq("4 - 10 Jan 10") # 2010-01-05
    expect(range[:labels][8]).to eq("11 - 17 Jan 10") # 2010-01-12
  end

  it "should prepare_range_for_months" do
    range = @utils.prepare_range({ :range => :months, :limit => 2, :offset => 0 })
    expect(range[:range]).to eq(:months)
    expect(range[:min]).to eq("2010002")
    expect(range[:max]).to eq("2010003")
    expect(range[:keys].size).to eq(2)
    expect(range[:keys][0]).to eq("2010002")
    expect(range[:keys][1]).to eq("2010003")
    expect(range[:labels].size).to eq(2)
    expect(range[:labels][0]).to eq("Feb 10")
    expect(range[:labels][1]).to eq("Mar 10")
  end

  it "should prepare_range_for_months_with_offset" do
    range = @utils.prepare_range({ :range => :months, :limit => 1, :offset => 1 })
    expect(range[:range]).to eq(:months)
    expect(range[:min]).to eq("2010002")
    expect(range[:max]).to eq("2010002")
  end

  it "should prepare_range_for_months_with_year_difference" do
    range = @utils.prepare_range({ :range => :months, :limit => 3, :offset => 1 })
    expect(range[:range]).to eq(:months)
    expect(range[:min]).to eq("2009012")
    expect(range[:max]).to eq("2010002")
    expect(range[:keys][0]).to eq("2009012")
    expect(range[:keys][1]).to eq("2010001")
  end

  it "should prepare_range_for_months_with_2_year_difference" do
    range = @utils.prepare_range({ :range => :months, :limit => 16, :offset => 1 })
    expect(range[:range]).to eq(:months)
    expect(range[:min]).to eq("2008011")
    expect(range[:max]).to eq("2010002")
    expect(range[:keys][1]).to eq("2008012")
    expect(range[:keys][2]).to eq("2009001")
    expect(range[:keys][13]).to eq("2009012")
    expect(range[:keys][14]).to eq("2010001")
  end

  it "should prepare_range_for_100_months" do
    range = @utils.prepare_range({ :range => :months, :limit => 100, :offset => 1 })
    expect(range[:range]).to eq(:months)
    expect(range[:min]).to eq("2001011")
    expect(range[:max]).to eq("2010002")
  end

  it "should prepare_range_for_100_weeks" do
    range = @utils.prepare_range({ :range => :weeks, :limit => 100, :offset => 1 })
    expect(range[:range]).to eq(:weeks)
    range[:min] # 2008-04-02.should == "2008013"
    expect(range[:max]).to eq("2010008")
  end

  it "should prepare_range_for_100_days" do
    range = @utils.prepare_range({ :range => :days, :limit => 100, :offset => 1 })
    expect(range[:range]).to eq(:days)
    range[:min] # 2009-11-23.should == "2009327"
    expect(range[:max]).to eq("2010061")
  end

end
end
