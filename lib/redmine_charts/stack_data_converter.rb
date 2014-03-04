module RedmineCharts
  module StackDataConverter

    include Redmine::I18n

    def self.convert(chart, data)
      tooltip = OFC2::Tooltip.new
      tooltip.hover

      chart.tooltip = tooltip

      bar = OFC2::BarStack.new
      bar.colours = RedmineCharts::Utils.colors

      keys = []
      values = []

      data[:sets].each_with_index do |set,i|
        set[1].each_with_index do |v,j|
          values[j] ||= []
          values[j][i] = if v.is_a? Array
            d = OFC2::BarStackValue.new(:value => v[0], :colour => RedmineCharts::Utils.color(i))
            d.tip = v[1] unless v[1].nil?
            d
          else
            v
          end
        end
        keys << OFC2::BarStackKey.new(:colour => RedmineCharts::Utils.color(i), :text => set[0], :font-size => 10)
      end

      keys << OFC2::BarStackKey.new(:colour => '#000000', :text => l(:charts_deviation_group_estimated), :font-size => 10)

      bar.values = values
      bar.set_keys keys

      chart << bar

      if data[:horizontal_line]
        shape = OFC2::Shape.new(:colour => '#000000')
        shape.values = [
          OFC2::ShapePoint.new(:x => -0.45, :y => data[:horizontal_line]),
          OFC2::ShapePoint.new(:x => -0.55 + values.size, :y => data[:horizontal_line]),
          OFC2::ShapePoint.new(:x => -0.55 + values.size, :y => data[:horizontal_line] + 1),
          OFC2::ShapePoint.new(:x => -0.45, :y => data[:horizontal_line] + 1),
        ]
        chart << shape
      end
    end

  end
end

# Fixes error with BarStackValue is OpenFlashChart ruby library
module OpenFlashChart
  class BarStackValue < Base
    def initialize(val,colour, args={})
      @val    = val
      @colour = colour
      super args
    end
  end
end

