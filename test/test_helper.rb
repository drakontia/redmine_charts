# Load the normal Rails helper
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

class Time
  def self.set_current_date=(date)
    @date = date
  end

  def self.now
    @date || Time.mktime(2010, 3, 11)
  end
end

class ChartTimeEntryTest < ActiveSupport::TestCase
  setup do
    Time.set_current_date = Time.mktime(2010, 3, 11)
  end
end

# Ensure that we are using the temporary fixture path
Engines::Testing.set_fixture_path
