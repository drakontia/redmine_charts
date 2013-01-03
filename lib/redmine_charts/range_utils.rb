module RedmineCharts
  module RangeUtils

    include Redmine::I18n

    @@types = [ :months, :weeks, :days ]
    @@days_per_year = 366
    @@weeks_per_year = 53
    @@months_per_year = 12
    @@seconds_per_day = 86400

    def self.types
      @@types
    end

    def self.options
      @@types.collect do |type|
        [l("charts_show_last_#{type}".to_sym), type]

      end
    end

    def self.default_range
      { :range => :weeks, :limit => 20, :offset => 0 }
    end

    def self.from_params(params)
      if params[:range] and params[:offset] and params[:limit]
        range = {}
        range[:range] = params[:range] ? params[:range].to_sym : :weeks
        range[:offset] = Integer(params[:offset])
        range[:limit] = Integer(params[:limit])
        range
      else
        nil
      end
    end

    def self.propose_range_for_two_dates(start_date, end_date)
      { :range => :days, :offset => (Date.today - end_date).to_i, :limit => (end_date - start_date).to_i + 1 }
    end

    def self.propose_range(start_date)
      if (diff = diff(start_date[:day], current_day, @@days_per_year)) <= 20
        type = :days
      elsif (diff = diff(start_date[:week], current_week, @@weeks_per_year)) <= 20
        type = :weeks
      else
        (diff = diff(start_date[:month], current_month, @@months_per_year))
        type = :months
      end

      diff = 10 if diff < 10

      { :range => type, :offset => 0, :limit => diff + 1}
    end

    def self.prepare_range(range)
      keys = []
      labels = []

      limit = range[:limit] - 1

      if range[:range] == :days
        current, label = subtract_day(current_day, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_day(current, 1)
          keys << current
          labels << label
        end
      elsif range[:range] == :weeks
        current, label = subtract_week(current_week, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_week(current, 1)
          keys << current
          labels << label
        end
      else
        current, label = subtract_month(current_month, range[:offset])

        keys << current
        labels << label

        limit.times do
          current, label = subtract_month(current, 1)
          keys << current
          labels << label
        end
      end

      keys.reverse!
      labels.reverse!

      range[:keys] = keys
      range[:labels] = labels
      range[:max] = keys.last
      range[:min] = keys.first

      range
    end

    private

    def self.format_week(date)
      date.strftime('%Y0%W')
    end

    def self.format_month(date)
      date.strftime('%Y0%m')
    end

    def self.format_day(date)
      date.strftime('%Y%j')
    end

    def self.format_date_with_unit(date, unit)
      case unit
      when :days
        format_day(date)
      when :weeks
        format_week(date)
      when :months
        format_month(date)
      end
    end

    def self.current_week
      format_week(Time.now)
    end

    def self.current_month
      format_month(Time.now)
    end

    def self.current_day
      format_day(Time.now)
    end

    def self.date_from_week(year_and_week_of_year)
      Date.strptime(year_and_week_of_year, "%Y0%W")
    end

    def self.date_from_month(year_and_month)
      Date.strptime(year_and_month, "%Y0%m")
    end

    def self.date_from_day(year_and_day_of_year)
      Date.strptime(year_and_day_of_year, "%Y%j")
    end

    def self.date_from_unit(date_string, unit)
      case unit
      when :days
        date_from_day(date_string)
      when :weeks
        date_from_week(date_string)
      when :months
        date_from_month(date_string)
      end
    end

    def self.diff(from, to, per_year)
      year_diff = to.to_s[0...4].to_i - from.to_s[0...4].to_i
      diff = to.to_s[4...7].to_i - from.to_s[4...7].to_i
      (year_diff * per_year) + diff
    end

    def self.subtract_month(current, offset)
      date = date_from_month(current) - offset.months
      [date.strftime("%Y0%m"), date.strftime("%b %y")]
    end

    def self.subtract_week(current, offset)
      begin
        date = Date.strptime(current, "%Y0%W") - offset.weeks
      rescue
        date = Date.strptime(current[0..3]+"001", "%Y0%W") - 7 - offset.weeks
      end

      key = "%d%03d" % [date.year, date.strftime("%W").to_i]

      date -= ((date.strftime("%w").to_i + 6) % 7).days

      day_from = date.strftime("%d").to_i
      month_from = date.strftime("%b")
      year_from = date.strftime("%y")

      date += 6.days

      day_to = date.strftime("%d").to_i
      month_to = date.strftime("%b")
      year_to = date.strftime("%y")

      if year_from != year_to
        label = "#{day_from} #{month_from} #{year_from} - #{day_to} #{month_to} #{year_to}"
      elsif month_from != month_to
        label = "#{day_from} #{month_from} - #{day_to} #{month_to} #{year_from}"
      else
        label = "#{day_from} - #{day_to} #{month_from} #{year_from}"
      end

      [key, label]
    end

    def self.subtract_day(current, offset)
      date = Date.strptime(current, "%Y%j") - offset

      key = "%d%03d" % [date.year, date.yday]

      [key, date.strftime("%d %b %y")]
    end

  end
end
