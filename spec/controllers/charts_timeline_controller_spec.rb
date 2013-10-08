require File.dirname(__FILE__) + '/../spec_helper'

describe ChartsTimelineController do

  include Redmine::I18n

  before do
    Time.set_current_date = Time.mktime(2010,3,12)
    Setting.default_language = 'en'
    @controller = ChartsTimelineController.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 1
  end

  it "should return data with range weeks offset 0" do
    get :index, :project_id => 15041, :project_ids => 15041, :limit => 10, :range => 'weeks', :offset => 0
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['x_axis']['min'].should == 0
    body['x_axis']['steps'].should == 1
    body['x_axis']['max'].should == 9
    body['x_axis']['labels']['labels'].size.should == 10
    body['elements'][0]['values'].size.should == 10

    body['x_axis']['labels']['labels'][0].should == '4 - 10 Jan 10'
    body['x_axis']['labels']['labels'][1].should == ""
    body['x_axis']['labels']['labels'][2].should == '18 - 24 Jan 10'
    body['x_axis']['labels']['labels'][3].should == ""
    body['x_axis']['labels']['labels'][4].should == '1 - 7 Feb 10'
    body['x_axis']['labels']['labels'][5].should == ""
    body['x_axis']['labels']['labels'][6].should == '15 - 21 Feb 10'
    body['x_axis']['labels']['labels'][7].should == ""
    body['x_axis']['labels']['labels'][8].should == '1 - 7 Mar 10'
    body['x_axis']['labels']['labels'][9].should == ""
  end

  it "should return data with range weeks offset 10" do
    get :index, :project_id => 15041, :project_ids => 15041, :offset => 10, :limit => 10, :range => 'weeks'
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['x_axis']['labels']['labels'].size.should == 10
    body['elements'][0]['values'].size.should == 10

    body['x_axis']['labels']['labels'][0].should == '26 Oct - 1 Nov 09'
    body['x_axis']['labels']['labels'][1].should == ""
    body['x_axis']['labels']['labels'][2].should == '9 - 15 Nov 09'
    body['x_axis']['labels']['labels'][3].should == ""
    body['x_axis']['labels']['labels'][4].should == '23 - 29 Nov 09'
    body['x_axis']['labels']['labels'][5].should == ""
    body['x_axis']['labels']['labels'][6].should == '7 - 13 Dec 09'
    body['x_axis']['labels']['labels'][7].should == ""
    body['x_axis']['labels']['labels'][8].should == '21 - 27 Dec 09'
    body['x_axis']['labels']['labels'][9].should == ""
  end

  it "should return data with range weeks offset 20" do
    get :index, :project_id => 15041, :project_ids => 15041, :offset => 20, :limit => 20, :range => 'weeks'
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['x_axis']['labels']['labels'].size.should == 20
    body['elements'][0]['values'].size.should == 20

    body['x_axis']['labels']['labels'][0].should == '8 - 14 Jun 09'
    body['x_axis']['labels']['labels'][1].should == ""
    body['x_axis']['labels']['labels'][2].should == ""
    body['x_axis']['labels']['labels'][3].should == ""
    body['x_axis']['labels']['labels'][4].should == '6 - 12 Jul 09'
    body['x_axis']['labels']['labels'][5].should == ""
    body['x_axis']['labels']['labels'][6].should == ""
    body['x_axis']['labels']['labels'][7].should == ""
    body['x_axis']['labels']['labels'][8].should == '3 - 9 Aug 09'
    body['x_axis']['labels']['labels'][9].should == ""
    body['x_axis']['labels']['labels'][10].should == ""
    body['x_axis']['labels']['labels'][11].should == ""
    body['x_axis']['labels']['labels'][12].should == '31 Aug - 6 Sep 09'
    body['x_axis']['labels']['labels'][13].should == ""
    body['x_axis']['labels']['labels'][14].should == ""
    body['x_axis']['labels']['labels'][15].should == ""
    body['x_axis']['labels']['labels'][16].should == '28 Sep - 4 Oct 09'
    body['x_axis']['labels']['labels'][17].should == ""
    body['x_axis']['labels']['labels'][18].should == ""
    body['x_axis']['labels']['labels'][19].should == ""
  end

  it "should return data with range months with offset 0" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'months', :limit => 10, :offset => 0
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['x_axis']['labels']['labels'].size.should == 10
    body['elements'][0]['values'].size.should == 10

    body['x_axis']['labels']['labels'][0].should == 'Jun 09'
    body['x_axis']['labels']['labels'][1].should == ""
    body['x_axis']['labels']['labels'][2].should == 'Aug 09'
    body['x_axis']['labels']['labels'][3].should == ""
    body['x_axis']['labels']['labels'][4].should == 'Oct 09'
    body['x_axis']['labels']['labels'][5].should == ""
    body['x_axis']['labels']['labels'][6].should == 'Dec 09'
    body['x_axis']['labels']['labels'][7].should == ""
    body['x_axis']['labels']['labels'][8].should == 'Feb 10'
    body['x_axis']['labels']['labels'][9].should == ""
  end

  it "should return data with range days with offset 0" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :limit => 10, :offset => 0
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['x_axis']['labels']['labels'].size.should == 10
    body['elements'][0]['values'].size.should == 10

    body['x_axis']['labels']['labels'][0].should == '03 Mar 10'
    body['x_axis']['labels']['labels'][1].should == ""
    body['x_axis']['labels']['labels'][2].should == '05 Mar 10'
    body['x_axis']['labels']['labels'][3].should == ""
    body['x_axis']['labels']['labels'][4].should == '07 Mar 10'
    body['x_axis']['labels']['labels'][5].should == ""
    body['x_axis']['labels']['labels'][6].should == '09 Mar 10'
    body['x_axis']['labels']['labels'][7].should == ""
    body['x_axis']['labels']['labels'][8].should == '11 Mar 10'
    body['x_axis']['labels']['labels'][9].should == ""
  end

  it "should return data without grouping" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :limit => 10, :offset => 0
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 1
    body['y_axis']['max'].should be_within( 1).of(9)
    body['y_legend']['text'].should == l(:charts_timeline_y)

    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(7.4)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(7.4, 2, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with range days with offset 0" do
    get :index, :project_id => 15041, :project_ids => [15041, 15042], :range => 'days', :limit => 10, :offset => 0
    response.should be_success

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(14.9)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 14.9 : 15.0

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 3, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(7.4)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(7.4, 2, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with grouping by users" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'user_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 3

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == 'John Smith'

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(3.3)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'Dave Lopper'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')

    body['elements'][2]['values'].size.should == 4
    body['elements'][2]['text'].should == 'Redmine Admin'

    body['elements'][2]['values'][0]['value'].should be_within( 0.1).of(3.3)
    body['elements'][2]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][2]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][2]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '10 Mar 10')
  end

  it "should return data with grouping_by_priorities" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'priority_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'High'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_authors" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'author_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should ==  l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'Redmine Admin'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_projects" do
    get :index, :project_id => 15041, :grouping => 'project_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 1

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == '#15041 Project1'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(7.4)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(7.4, 2, '10 Mar 10')
  end

  it "should return data with grouping_by_statuses" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'status_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'New'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_trackers" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'tracker_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'Bug'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_issues" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'issue_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == '#15045 Issue5'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_versions" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'fixed_version_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == '2.0'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_categories" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'category_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'Category2'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == l(:charts_group_none)

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with grouping_by_activities" do
    get :index, :project_id => 15041, :project_ids => 15041, :grouping => 'activity_id', :range => 'days', :limit => 4, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'].size.should == 2

    body['elements'][0]['values'].size.should == 4
    body['elements'][0]['text'].should == 'Design'

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(3.3)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')

    body['elements'][1]['values'].size.should == 4
    body['elements'][1]['text'].should == 'Development'

    body['elements'][1]['values'][0]['value'].should be_within( 0.1).of(3.3)
    body['elements'][1]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][1]['values'][1]['value'].should be_within( 0.1).of(5.1)
    body['elements'][1]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
  end

  it "should return data with users_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :user_ids => 1, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(4.3)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 1, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(3.3)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with issues_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :issue_ids => 15045, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "")    .should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with activities_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :activity_ids => 9, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 4.3 : 4.4

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(4.3)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 1, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(3.3)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(3.3, 1, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(5.1)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(5.1, 1, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with priorities_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :priority_ids => 4, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with trackers_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :tracker_ids => 1, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with versions_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :limit => 10, :fixed_version_ids => 15042, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with categories_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :category_ids => 15042, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(6.6)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(6.6, 2, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end


  it "should return data with status_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :status_ids => 2, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(7.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 7.6 : 7.7

    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with author_condition" do
    get :index, :project_id => 15041, :project_ids => 15041, :range => 'days', :author_ids => 2, :limit => 10, :offset => 0

    body = ActiveSupport::JSON.decode(assigns[:data])
    body['elements'][0]['values'].size.should == 10
    body['elements'][0]['text'].should == l(:charts_group_all)

    body['elements'][0]['values'][0]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][0]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '03 Mar 10')
    body['elements'][0]['values'][1]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][1]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '04 Mar 10')
    body['elements'][0]['values'][2]['value'].should be_within( 0.1).of(2.3)
    body['elements'][0]['values'][2]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(2.3, 1, '05 Mar 10')
    body['elements'][0]['values'][3]['value'].should be_within( 0.1).of(6.6)

    tmp = ActiveRecord::Base.connection.adapter_name =~ /postgresql|sqlite/i ? 6.6 : 6.7

    body['elements'][0]['values'][3]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(tmp, 2, '06 Mar 10')
    body['elements'][0]['values'][4]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][4]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '07 Mar 10')
    body['elements'][0]['values'][5]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][5]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '08 Mar 10')
    body['elements'][0]['values'][6]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][6]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '09 Mar 10')
    body['elements'][0]['values'][7]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][7]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '10 Mar 10')
    body['elements'][0]['values'][8]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][8]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '11 Mar 10')
    body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(0)
    body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(0, 0, '12 Mar 10')
  end

  it "should return data with sub_tasks" do
    if RedmineCharts.has_sub_issues_functionality_active
      get :index, :project_id => 15044, :project_ids => 15044, :range => 'weeks', :limit => 10, :offset => 0

      body = ActiveSupport::JSON.decode(assigns[:data])
      body['elements'][0]['values'].size.should == 10
      body['elements'][0]['text'].should == l(:charts_group_all)

      body['elements'][0]['values'][9]['value'].should be_within( 0.1).of(13.2)
      body['elements'][0]['values'][9]['tip'].gsub("\\u003C", "<").gsub("\\u003E", ">").gsub("\000", "").should == get_label(13.2, 4, '8 - 14 Mar 10')
    end
  end

  it "should return data with all_conditions" do
    get :index, :project_id => 15041, :category_ids => 15043, :tracker_ids => 15043, :fixed_version_ids => 15043, :fixed_version_ids => 15041, :user_ids => 15043, :issue_ids => 15043, :activity_ids => 15043, :author_ids => 1, :status_ids => 5
    response.should be_success
  end

  def get_label(hours, entries, date)
    if(hours > 0)
      "#{l(:charts_timeline_hint, :hours => hours, :entries => entries)}<br>#{date}"
    else
      "#{l(:charts_timeline_hint_empty)}<br>#{date}"
    end
  end

end
