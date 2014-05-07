module RedmineCharts
  module LineDataConverter

    include Redmine::I18n

    def self.convert(chart, data)
      index = 0

      data[:sets].each do |set|
        line = OFC2::Line.new
        line.text = set[0]
        line.width = 2
        line.colour = RedmineCharts::Utils.color(index)
        line.dot_size =  2

        j = -1

        vals = set[1].collect do |v|
          j += 1
          if v.is_a? Array
            d = OFC2::Dot.new
            d.value = v[0]
            if v[2]
              d.dot_size = 4
            end
            d.colour = RedmineCharts::Utils.color(index)
            d.tip = "#{v[1]}<br>#{data[:labels][j]}" unless v[1].nil?
            d
          else
            v
          end
        end

        line.values = vals

        chart.add_element(line)
        index += 1
      end
    end

  end
end
