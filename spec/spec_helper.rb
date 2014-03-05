require 'date_time_attribute'
require 'active_record'

shared_context 'use active record', use_active_record: true do
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

  ActiveRecord::Schema.define do
    create_table 'models' do |table|
      table.column :created_at, :datetime
    end
  end

  class Model < ActiveRecord::Base
    include DateTimeAttribute
    date_time_attribute :created_at
  end

  Model.create! created_at: '2014-01-01 12:00:00 +0000'

end

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.formatter = :documentation
end
