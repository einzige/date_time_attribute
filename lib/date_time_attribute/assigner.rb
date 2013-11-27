module DateTimeAttribute
  class Holder < Struct.new(:date_time, :date, :time)
    def date=(val)
      @date = parse(val, :to_date)
      update_date_time
      @date
    end

    def time=(val)
      @time = parse(val, :to_time)
      update_date_time
      @time
    end

    def date
      @date || date_time.try(:to_date)
    end

    def time
      @time || date_time.try(:to_time)
    end

    def self.parser
      @parser || Time.zone
    end

    def self.parser=(val)
      @parser = val
    end

    private

    def parse(val, modifier)
      case val
        when String
          self.class.parser.parse(val).try(modifier)
        when Date, Time, DateTime, ActiveSupport::TimeWithZone
          val.send(modifier)
        when nil
        else
          raise ArgumentError, "Expected Date, Time, String, got #{val.class.name}"
      end
    end

    def update_date_time
      if @date || @time
        @date_time = self.class.parser.parse("#{date.try(:strftime, '%Y-%m-%d')} #{time.try(:strftime, '%H:%M')}")
      end
    end
  end
end
