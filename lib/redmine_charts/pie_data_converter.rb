module RedmineCharts
  module PieDataConverter

    def self.convert(chart, data)
      tooltip = OFC2::Tooltip.new
      tooltip.hover

      chart.tooltip = tooltip

      data[:sets].each do |set|
        pie = OFC2::Pie.new(
          :start_angle => 35,
          :animate =>  [OFC2::PieFade.new, OFC2::PieBounce.new],
          :colours => RedmineCharts::Utils.colors
        )

        vals = []

        set[1].each_with_index do |v, index|
          if v.is_a? Array
            d = OFC2::PieValue.new(:value => v[0], :label => data[:labels][index])
            d.tip = v[1] unless v[1].nil?
            vals << d
          else
            vals << v
          end
        end

        pie.values = vals

        chart << pie
      end
    end

  end
end
