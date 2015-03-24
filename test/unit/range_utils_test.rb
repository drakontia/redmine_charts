require File.dirname(__FILE__) + '/../test_helper'

class RangeUtilsTest < ActiveSupport::TestCase
  setup do
    Time.set_current_date = Time.mktime(2010, 3, 3)
  end

  def test_if_return_range_types
    assert_equal [:months, :weeks, :days], RedmineCharts::RangeUtils.types
  end

  def test_if_set_range_if_not_provided_in_params
    range = RedmineCharts::RangeUtils.from_params({})
    assert_nil range
  end

  def test_if_can_read_range_type_from_params
    range = RedmineCharts::RangeUtils.from_params(range: 'days')
    assert_nil range
  end

  def test_if_can_read_range_offset_from_params
    range = RedmineCharts::RangeUtils.from_params(offset: '1')
    assert_nil range
  end

  def test_if_can_read_range_limit_from_params
    range = RedmineCharts::RangeUtils.from_params(limit: '11')
    assert_nil range
  end

  def test_if_can_read_range_from_params
    range = RedmineCharts::RangeUtils.from_params(offset: '2', range: 'months', limit: '11')
    assert_equal :months, range[:range]
    assert_equal 2, range[:offset]
    assert_equal 11, range[:limit]
  end

  def test_if_can_propose_range_for_today
    range = RedmineCharts::RangeUtils.propose_range(week: '2010009', month: '201003', day: '2010062')
    assert_equal :days, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 11, range[:limit]
  end

  def test_if_can_propose_range_for_10_days_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2010008', month: '2010003', day: '2010052')
    assert_equal :days, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 11, range[:limit]
  end

  def test_if_can_propose_range_for_20_days_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2010007', month: '2010003', day: '2010042')
    assert_equal :days, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 21, range[:limit]
  end

  def test_if_can_propose_range_for_21_days_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2010006', month: '2010003', day: '2010041')
    assert_equal :weeks, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 11, range[:limit]
  end

  def test_if_can_propose_range_for_20_weeks_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2009042', month: '2009011', day: '2009300')
    assert_equal :weeks, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 21, range[:limit]
  end

  def test_if_can_propose_range_for_21_weeks_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2009040', month: '2009011', day: '2009300')
    assert_equal :months, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 11, range[:limit]
  end

  def test_if_can_propose_range_for_21_months_ago
    range = RedmineCharts::RangeUtils.propose_range(week: '2009039', month: '2008001', day: '2009300')
    assert_equal :months, range[:range]
    assert_equal 0, range[:offset]
    assert_equal 27, range[:limit]
  end

  def test_if_can_prepare_range_for_days
    range = RedmineCharts::RangeUtils.prepare_range(range: :days, limit: 10, offset: 0)
    assert_equal :days, range[:range]
    assert_equal '2010053', range[:min]
    assert_equal '2010062', range[:max]
    assert_equal 10, range[:keys].size
    assert_equal '2010053', range[:keys][0]
    assert_equal '2010054', range[:keys][1]
    assert_equal '2010055', range[:keys][2]
    assert_equal '2010056', range[:keys][3]
    assert_equal '2010057', range[:keys][4]
    assert_equal '2010058', range[:keys][5]
    assert_equal '2010059', range[:keys][6]
    assert_equal '2010060', range[:keys][7]
    assert_equal '2010061', range[:keys][8]
    assert_equal '2010062', range[:keys][9]
    assert_equal 10, range[:labels].size
    assert_equal '22 Feb 10', range[:labels][0]
    assert_equal '23 Feb 10', range[:labels][1]
    assert_equal '24 Feb 10', range[:labels][2]
    assert_equal '25 Feb 10', range[:labels][3]
    assert_equal '26 Feb 10', range[:labels][4]
    assert_equal '27 Feb 10', range[:labels][5]
    assert_equal '28 Feb 10', range[:labels][6]
    assert_equal '01 Mar 10', range[:labels][7]
    assert_equal '02 Mar 10', range[:labels][8]
    assert_equal '03 Mar 10', range[:labels][9]
  end

  def test_if_can_prepare_range_for_days_with_offset
    range = RedmineCharts::RangeUtils.prepare_range(range: :days, limit: 10, offset: 5)
    assert_equal :days, range[:range]
    assert_equal '2010048', range[:min]
    assert_equal '2010057', range[:max]
  end

  def test_if_can_prepare_range_for_days_with_year_difference
    range = RedmineCharts::RangeUtils.prepare_range(range: :days, limit: 60, offset: 5)
    assert_equal :days, range[:range]
    assert_equal '2009363', range[:min] # 2009-12-29
    assert_equal '2010057', range[:max]
    assert_equal '2009364', range[:keys][1] # 2009-12-30
    assert_equal '2009365', range[:keys][2] # 2009-12-31
    assert_equal '2010001', range[:keys][3]
  end

  def test_if_can_prepare_range_for_weeks
    range = RedmineCharts::RangeUtils.prepare_range(range: :weeks, limit: 5, offset: 0)
    assert_equal :weeks, range[:range]
    assert_equal '2010005', range[:min]
    assert_equal '2010009', range[:max]
  end

  def test_if_can_prepare_range_for_weeks_with_offset
    range = RedmineCharts::RangeUtils.prepare_range(range: :weeks, limit: 5, offset: 1)
    assert_equal :weeks, range[:range]
    assert_equal '2010004', range[:min]
    assert_equal '2010008', range[:max]
  end

  def test_if_can_prepare_range_for_weeks_with_year_difference
    range = RedmineCharts::RangeUtils.prepare_range(range: :weeks, limit: 15, offset: 1)
    assert_equal :weeks, range[:range]
    assert_equal '2009046', range[:min] # 2009-11-18
    assert_equal '2010008', range[:max]
    assert_equal 15, range[:keys].size
    assert_equal '2009046', range[:keys][0] # 2009-11-18
    assert_equal '2009050', range[:keys][4] # 2009-12-16
    assert_equal '2009051', range[:keys][5] # 2009-12-23
    assert_equal '2010000', range[:keys][6] # 2009-12-30
    assert_equal '2010001', range[:keys][7]
    assert_equal '2010008', range[:keys][14]
    assert_equal 15, range[:labels].size
    assert_equal '30 Nov - 6 Dec 09', range[:labels][2]
    assert_equal '21 - 27 Dec 09', range[:labels][5]
    assert_equal '28 Dec 09 - 3 Jan 10', range[:labels][6]
    assert_equal '4 - 10 Jan 10', range[:labels][7] # 2010-01-05
    assert_equal '11 - 17 Jan 10', range[:labels][8] # 2010-01-12
  end

  def test_if_can_prepare_range_for_months
    range = RedmineCharts::RangeUtils.prepare_range(range: :months, limit: 2, offset: 0)
    assert_equal :months, range[:range]
    assert_equal '2010002', range[:min]
    assert_equal '2010003', range[:max]
    assert_equal 2, range[:keys].size
    assert_equal '2010002', range[:keys][0]
    assert_equal '2010003', range[:keys][1]
    assert_equal 2, range[:labels].size
    assert_equal 'Feb 10', range[:labels][0]
    assert_equal 'Mar 10', range[:labels][1]
  end

  def test_if_can_prepare_range_for_months_with_offset
    range = RedmineCharts::RangeUtils.prepare_range(range: :months, limit: 1, offset: 1)
    assert_equal :months, range[:range]
    assert_equal '2010002', range[:min]
    assert_equal '2010002', range[:max]
  end

  def test_if_can_prepare_range_for_months_with_year_difference
    range = RedmineCharts::RangeUtils.prepare_range(range: :months, limit: 3, offset: 1)
    assert_equal :months, range[:range]
    assert_equal '2009012', range[:min]
    assert_equal '2010002', range[:max]
    assert_equal '2009012', range[:keys][0]
    assert_equal '2010001', range[:keys][1]
  end

  def test_if_can_prepare_range_for_months_with_2_year_difference
    range = RedmineCharts::RangeUtils.prepare_range(range: :months, limit: 16, offset: 1)
    assert_equal :months, range[:range]
    assert_equal '2008011', range[:min]
    assert_equal '2010002', range[:max]
    assert_equal '2008012', range[:keys][1]
    assert_equal '2009001', range[:keys][2]
    assert_equal '2009012', range[:keys][13]
    assert_equal '2010001', range[:keys][14]
  end

  def test_if_can_prepare_range_for_100_months
    range = RedmineCharts::RangeUtils.prepare_range(range: :months, limit: 100, offset: 1)
    assert_equal :months, range[:range]
    assert_equal '2001011', range[:min]
    assert_equal '2010002', range[:max]
  end

  def test_if_can_prepare_range_for_100_weeks
    range = RedmineCharts::RangeUtils.prepare_range(range: :weeks, limit: 100, offset: 1)
    assert_equal :weeks, range[:range]
    assert_equal '2008013', range[:min] # 2008-04-02
    assert_equal '2010008', range[:max]
  end

  def test_if_can_prepare_range_for_100_days
    range = RedmineCharts::RangeUtils.prepare_range(range: :days, limit: 100, offset: 1)
    assert_equal :days, range[:range]
    assert_equal '2009327', range[:min] # 2009-11-23
    assert_equal '2010061', range[:max]
  end
end
