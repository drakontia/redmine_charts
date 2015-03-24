require File.dirname(__FILE__) + '/../test_helper'

class GroupingUtilsTest < ActiveSupport::TestCase
  def test_if_return_default_if_nothing_is_specified
    assert_equal({ page: 1, per_page: 10 }, RedmineCharts::PaginationUtils.from_params({}))
  end

  def test_if_return_page_and_perpage
    assert_equal({ page: 2, per_page: 10 }, RedmineCharts::PaginationUtils.from_params(page: '2'))
    assert_equal({ page: 4, per_page: 10 }, RedmineCharts::PaginationUtils.from_params(page: 4))
    assert_equal({ page: 1, per_page: 11 }, RedmineCharts::PaginationUtils.from_params(per_page: '11'))
    assert_equal({ page: 1, per_page: 12 }, RedmineCharts::PaginationUtils.from_params(per_page: 12))
    assert_equal({ page: 3, per_page: 13 }, RedmineCharts::PaginationUtils.from_params(page: '3', per_page: 13))
  end
end
