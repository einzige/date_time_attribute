require 'rubygems'
require 'active_support'
require 'date_time_attribute/assigner'

module DateTimeAttribute
  extend ActiveSupport::Concern

  def date_time_holder(attribute)
    (@date_time_holder ||= {})[attribute] ||= DateTimeAttribute::Holder.new(send(attribute))
  end

  def self.parser
    DateTimeAttribute::Holder.parser
  end

  def self.parser=(val)
    DateTimeAttribute::Holder.parser = val
  end

  module ClassMethods
    def date_time_attribute(attribute)
      define_method("#{attribute}_date") do
        date_time_holder(attribute).date
      end

      define_method("#{attribute}_time") do
        date_time_holder(attribute).time
      end

      define_method("#{attribute}_date=") do |val|
        date_time_holder(attribute).date = val
      end
    end
  end
end
