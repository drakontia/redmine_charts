class ChartsController < ApplicationController

  unloadable

  menu_item :charts

  before_filter :find_project

  before_filter :authorize, :only => [:index]

  def controller_name
    "charts"
  end

  # Show main page with conditions form and chart
  def index
    @title = get_title

    if show_date_condition
      @date_condition = true
    else
      @date_condition = false
    end

    if show_pages
      @show_pages = true
    end

    unless get_grouping_options.empty?
      @grouping_options = RedmineCharts::GroupingUtils.to_options(get_grouping_options)
    else
      @grouping_options = []
    end

    @textconditions_options = []

    unless get_conditions_options.empty?
      @conditions_options     = RedmineCharts::ConditionsUtils.to_options(@project, get_conditions_options)
      @textconditions_options = @conditions_options.select { |c1,c2| c2.nil? }.to_a
      @conditions_options     = @conditions_options.select { |c1,c2| not c2.nil? }.to_a
    else
      @conditions_options = []
    end

    unless get_multiconditions_options.empty?
      @multiconditions_options = RedmineCharts::ConditionsUtils.to_options(@project, get_multiconditions_options)
      @textconditions_options  = @multiconditions_options.select { |c1,c2| c2.nil? }.to_a
      @multiconditions_options = @multiconditions_options.select { |c1,c2| not c2.nil? }.to_a
    else
      @multiconditions_options = []
    end

    @all_conditions_options = @conditions_options + @multiconditions_options + @textconditions_options

    unless get_help.blank?
      @help = get_help
      @show_left_column = true
    else
      @help = nil
    end

    @range      = RedmineCharts::RangeUtils.from_params(params)
    @pagination = RedmineCharts::PaginationUtils.from_params(params)
    @grouping   = RedmineCharts::GroupingUtils.from_params(get_grouping_options, params)
    @conditions = RedmineCharts::ConditionsUtils.from_params(get_conditions_options + get_multiconditions_options, @project.id, params)

    if params[:chart_form_action] == 'saved_condition_update'
      @saved_condition = create_saved_condition(:update, @conditions, @grouping)
    elsif params[:chart_form_action] == 'saved_condition_create'
      @saved_condition = create_saved_condition(:create, @conditions, @grouping)
    end

    unless @saved_condition
      @saved_condition = ChartSavedCondition.first(:conditions => {:id => params[:saved_condition_id]}) if not params[:saved_condition_id].blank?
    end

    @saved_conditions = ChartSavedCondition.all(:conditions => ["project_id is null or project_id = ?", @project.id])

    create_chart

    if @error and not flash[:error]
      flash.now[:error] = l(@error)
    end

    render :template => "charts/index"
  end

  def destroy_saved_condition
    condition = ChartSavedCondition.first(:conditions => {:id => params[:id]})

    unless condition
      flash.now[:error] = l(:charts_saved_condition_flash_not_found)
    else
      condition.destroy
      flash[:notice] = l(:charts_saved_condition_flash_deleted)
    end

    redirect_to :action => :index
  end

  protected

  # Return data for chart
  def create_chart
    chart = OpenFlashChart.new

    data = get_data

    if data[:error]
      @error = data[:error]
      @data = nil
    else
      get_converter.convert(chart, data)

      if get_y_legend
        y = YAxis.new
        y.set_range(0,(data[:max]*1.2).round,(data[:max]/get_y_axis_labels).round) if data[:max]
        chart.y_axis = y
      end

      if get_x_legend
        x = XAxis.new
        x.set_range(0,data[:count] > 1 ? data[:count] - 1 : 1,1) if data[:count]
        if data[:labels]
          labels = []
          if get_x_axis_labels > 0
            step = (data[:labels].size/get_x_axis_labels).to_i
            step = 1 if step == 0
          else
            step = 1
          end
          data[:labels].each_with_index do |l,i|
            if i % step == 0
              labels << l
            else
              labels << ""
            end
          end
          x.set_labels(labels)
        end
        chart.x_axis = x
      else
        x = XAxis.new
        x.set_labels([""])
        chart.x_axis = x
      end

      unless get_x_legend.nil?
        legend = XLegend.new(get_x_legend)
        legend.set_style('{font-size: 12px}')
        chart.set_x_legend(legend)
      end

      unless get_x_legend.nil?
        legend = YLegend.new(get_y_legend)
        legend.set_style('{font-size: 12px}')
        chart.set_y_legend(legend)
      end

      chart.set_bg_colour('#ffffff');

      @data = chart.to_s
    end
  end

  def title
    get_title
  end

  # Returns chart title
  def get_title
    nil
  end

  # Returns chart type: line, pie or stack
  def get_type
    :line
  end

  # Returns help string, displayed above chart
  def get_help
    nil
  end

  # Returns data for chart
  def get_data
    raise "overwrite it"
  end

  # Returns hints for given record and grouping type
  def get_hints(record)
    nil
  end

  # Returns Y legend
  def get_x_legend
    nil
  end

  # Returns Y legend
  def get_y_legend
    nil
  end

  # Returns how many labels should be displayed on x axis. 0 means all labels.
  def get_x_axis_labels
    5
  end

  # Returns how many labels should be displayed on y axis. 0 means all labels.
  def get_y_axis_labels
    5
  end

  # Returns true if date condition should be displayed
  def show_date_condition
    false
  end

  # Returns true if pagination should be displayed
  def show_pages
    false
  end

  # Returns values for grouping options
  def get_grouping_options
    []
  end

  # Returns type of conditions available for that chart
  def get_conditions_options
    []
  end

  # Returns type of conditions available for that chart
  def get_multiconditions_options
    []
  end

  private

  # Returns converter for given chart type
  def get_converter
    eval("RedmineCharts::#{get_type.to_s.camelize}DataConverter")
  end

  # Finds current project or raises 404
  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def create_saved_condition(action, conditions, grouping)
    if action == :create
      condition = ChartSavedCondition.new
    else
      condition = ChartSavedCondition.first(:conditions => {:id => params[:saved_condition_id]})
    end

    unless condition
      flash.now[:error] = l(:charts_saved_condition_flash_not_found)
    else
      condition.name = params["saved_condition_#{action}_name".to_sym]
      condition.project_id = params["saved_condition_#{action}_project_id".to_sym]
      condition.chart = self.class.name.underscore.sub("charts_","").sub("_controller","")

      conditions[:grouping] = grouping

      condition.conditions = conditions

      if condition.save
        flash.now[:notice] = l("charts_saved_condition_flash_#{action}d".to_sym)
        condition
      else
        if condition.errors
          if condition.errors[:name] == 'can\'t be blank'
            flash.now[:error] = l(:charts_saved_condition_flash_name_cannot_be_blank)
          elsif condition.errors[:name] == 'has already been taken'
            flash.now[:error] = l(:charts_saved_condition_flash_name_exists)
          else
            flash.now[:error] = condition.errors.full_messages.join("<br/>")
          end
        end

        nil
      end
    end
  end

end
