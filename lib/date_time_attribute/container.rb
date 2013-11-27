require 'active_support/core_ext/object/try'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/module/delegation'

module DateTimeAttribute
  class Container < Struct.new(:date_time, :date, :time, :time_zone)
    delegate :year, :month, :day, :hour, to: :date_time

    def in_time_zone(time_zone)
      self.time_zone = time_zone
      update_date_time
      self
    end

    def time_zone
      @time_zone
    end

    def time_zone=(val)
      (@time_zone = val).tap { update_date_time }
    end

    def date=(val)
      @date = parse(val)
      update_date_time
      @date
    end

    def time=(val)
      @time = parse(val)
      update_date_time
      @time
    end

    def date
      @date || date_time
    end

    def time
      @time || date_time
    end

    def self.parser
      @parser || Time.zone || Time
    end

    def self.parser=(val)
      @parser = val
    end

    private

    def parse(val)
      case val
        when String
          self.class.parser.parse(val)
        when Date, Time, DateTime, ActiveSupport::TimeWithZone
          val.send(modifier)
        when nil
        else
          raise ArgumentError, "Expected Date, Time, String, got #{val.class.name}"
      end
    end

    def update_date_time
      if @date || @time
        date_time = self.class.parser.parse("#{date.try(:strftime, '%Y-%m-%d')} #{time.try(:strftime, '%H:%M')}")

        if time_zone
          self.date_time = date_time.in_time_zone(time_zone)
        else
          self.date_time = date_time
        end
      end
    end
  end
end
