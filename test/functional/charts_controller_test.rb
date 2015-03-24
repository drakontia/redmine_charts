require File.dirname(__FILE__) + '/../test_helper'
require 'charts_controller'

class ChartsController
  def rescue_action(e)
    fail e
  end

  def authorize
    true
  end

  def get_data_value
    @data
  end
end

class ChartsControllerTest < ActionController::TestCase
  include Redmine::I18n

  protected

  def get_data(options = {})
    get :index, options
    assert_response :success
    ActiveSupport::JSON.decode(@controller.get_data_value) if @controller.get_data_value
  end
end
