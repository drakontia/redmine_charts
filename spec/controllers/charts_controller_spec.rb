require File.dirname(__FILE__) + '/../rails_helper'

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

Rspec.describe ChartsController, type: :controller do

  include Redmine::I18n

  protected

  def get_data(options = {})
    get :index, options
    expect(response).to be_success
    ActiveSupport::JSON.decode(@controller.get_data_value) if @controller.get_data_value
  end

end
