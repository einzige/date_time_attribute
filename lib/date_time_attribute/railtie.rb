module DateTimeAttribute
  class Railtie < Rails::Railtie
    initializer 'date_time_attribute.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :include, DateTimeAttribute
      end
    end
  end
end

