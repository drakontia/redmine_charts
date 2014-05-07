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
      dates = "%d%03d" % [date.year, date.cweek]
      dates
    end

    def self.format_month(date)
      dates = "%d%03d" % [date.year, date.month]
      dates
    end

    def self.format_day(date)
      dates = "%d%03d" % [date.year, date.yday]
      dates
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
      format_week(Time.now.to_date)
    end

    def self.current_month
      format_month(Time.now.to_date)
    end

    def self.current_day
      format_day(Time.now.to_date)
    end

    def self.date_from_week(year_and_week_of_year)
      Date.commercial(year_and_week_of_year[0..3].to_i, year_and_week_of_year[4..7].to_i)
    end

    def self.date_from_month(year_and_month)
      Date.civil(year_and_month[0..3].to_i, year_and_month[4..7].to_i)
    end

    def self.date_from_day(year_and_day_of_year)
      Date.ordinal(year_and_day_of_year[0..3].to_i, year_and_day_of_year[4..7].to_i)
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
      [format_month(date), date.strftime("%b %y")]
    end

    def self.subtract_week(current, offset)
      begin
        date = Date.commercial(current[0..3].to_i, current[4..7].to_i, 1) - offset.weeks
      rescue
        date = Date.commercial(current[0..3].to_i - 1, -1, 1) - offset.weeks
      end

      key = "%d%03d" % [date.year, date.cweek]

      day_from = date.mday
      month_from = date.strftime("%b")
      year_from = date.strftime("%y")

      date += 6.days

      day_to = date.mday
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
      date = Date.ordinal(current[0..3].to_i, current[4..7].to_i) - offset

      key = "%d%03d" % [date.year, date.yday]

      [key, date.strftime("%d %b %y")]
    end

  end
end
