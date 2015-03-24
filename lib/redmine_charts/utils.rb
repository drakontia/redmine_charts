module RedmineCharts
  module Utils
    @@colors = ['#80C31C', '#FF7900', '#DFC329', '#00477F', '#d01f3c', '#356aa0', '#C79810', '#4C88BE', '#5E4725', '#6363AC']

    @@controllers = %w(burndown burndown2 ratio timeline deviation issue).map { |name| [name.to_sym, "charts_#{name}".to_sym] }

    # Returns default controller name, which should be entry when user click 'charts' label in project menu.
    # See init.rb.
    def self.default_controller
      @@controllers.first[1].to_s
    end

    # Returns array of controllers for builing permissions configuration.
    # See init.rb.
    def self.controllers_for_permissions
      Hash[*(@@controllers.map { |controller| [controller[1], :index] }.flatten)]
    end

    # Get block and call it with two parameters - controller path name and controller name.
    # See routes.rb.
    def self.controllers_for_routing(&block)
      @@controllers.each { |controller| block.call(controller[0].to_s, controller[1].to_s) }
    end

    def self.colors
      @@colors
    end

    def self.color(i)
      @@colors[i % @@colors.length]
    end

    def self.round(i)
      ((i.to_f * 10).ceil).to_f / 10
    end

    def self.percent(value, total)
      if total > 0
        (value.to_f / total * 100).round
      else
        0
      end
    end
  end
end
