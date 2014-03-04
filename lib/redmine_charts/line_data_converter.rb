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

        #vals = set[1].collect do |v|
        set[1].collect do |v|
          j += 1
          if v.is_a? Array
            line.values = (v[0])
            if v[2]
              line.dot_size = 4
            end
            line.colour = RedmineCharts::Utils.color(index)
            line.tip = "#{v[1]}<br>#{data[:labels][j]}" unless v[1].nil?
          else
            line.values = v
          end
        end

        #line.values = vals

        chart << line
        index += 1
      end
    end

  end
end
