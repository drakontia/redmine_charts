require File.dirname(__FILE__) + '/../spec_helper'

describe ChartIssueStatus do

  before(:all) do
    @status  = ChartIssueStatus.new
    Time.set_current_date = Time.mktime(2010, 4, 1)
  end

  it 'should generate new' do
    @status.day  =  1
    expect(@status).to be_valid
    expect(@status.day).to eq(1)
  end

end
