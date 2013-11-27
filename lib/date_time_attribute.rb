require 'rubygems'
require 'active_support'
require 'date_time_attribute/container'

module DateTimeAttribute
  extend ActiveSupport::Concern

  def date_time_holder(attribute)
    (@date_time_holder ||= {})[attribute] ||= DateTimeAttribute::Container.new(send(attribute))
  end

  def self.parser
    DateTimeAttribute::Container.parser
  end

  def self.parser=(val)
    DateTimeAttribute::Container.parser = val
  end

  def self.in_time_zone(zone)
    case zone
    when nil
      yield
    when Time::Zone, String
      old_zone = Time.zone
      Time.zone = zone
      yield.tap { Time.zone = old_zone }
    when Proc, Symbol
      old_zone = Time.zone
      Time.zone = zone.to_proc.call
      yield.tap { Time.zone = old_zone }
    else
      raise ArgumentError, "Expected timezone, got #{zone.inspect}"
    end
  end

  module ClassMethods
    def date_time_attribute(attribute, opts = {})
      attribute = attribute.to_sym
      time_zone = opts[:time_zone]

      unless instance_methods.include?(attribute)
        attr_accessor attribute
      end

      define_method("#{attribute}_date") do
        DateTimeAttribute.in_time_zone(time_zone) do
          date_time_holder(attribute).date
        end
      end

      define_method("#{attribute}_time") do
        DateTimeAttribute.in_time_zone(time_zone) do
          date_time_holder(attribute).time
        end
      end

      define_method("#{attribute}_date=") do |val|
        DateTimeAttribute.in_time_zone(time_zone) do
          holder = date_time_holder(attribute)
          (holder.date = val).tap do
            self.send("#{attribute}=", holder.date_time)
          end
        end
      end

      define_method("#{attribute}_time=") do |val|
        DateTimeAttribute.in_time_zone(time_zone) do
          holder = date_time_holder(attribute)
          (holder.time = val).tap do
            self.send("#{attribute}=", holder.date_time)
          end
        end
      end
    end
  end
end
