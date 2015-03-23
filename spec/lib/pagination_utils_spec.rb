require File.dirname(__FILE__) + '/../spec_helper'

module RedmineCharts
describe GroupingUtils do
  before(:all) do
    @utils = RedmineCharts::PaginationUtils
  end

  it "should return_default_if_nothing_is_specified" do
    expect(@utils.from_params({})).to eq({:page => 1, :per_page => 10})
  end

  it "should return_page_and_perpage" do
    expect(@utils.from_params({:page => "2"})).to eq({:page => 2, :per_page => 10})
    expect(@utils.from_params({:page => 4})).to eq({:page => 4, :per_page => 10})
    expect(@utils.from_params({:per_page => "11"})).to eq({:page => 1, :per_page => 11})
    expect(@utils.from_params({:per_page => 12})).to eq({:page => 1, :per_page => 12})
    expect(@utils.from_params({:page => "3", :per_page => 13})).to eq({:page => 3, :per_page => 13})
  end

end
end
