# DateTime attribute for Ruby!
[![Gem Version](https://badge.fury.io/rb/date_time_attribute.png)](http://badge.fury.io/rb/date_time_attribute)
[![Build Status](https://travis-ci.org/einzige/date_time_attribute.png?branch=master)](https://travis-ci.org/einzige/date_time_attribute)
[![Dependency Status](https://gemnasium.com/einzige/date_time_attribute.png)](https://gemnasium.com/einzige/date_time_attribute)

Splits access of DateTime attribute(s) into seperate Date, Time and TimeZone attributes. Compatible with ActiveRecord as well as with Rails.

## Install

```bash
gem install date_time_attribute
```

## Enjoy

```ruby
require 'date_time_attribute'

class Task
  include DateTimeAttribute
  date_time_attribute :due_at
end

task = Task.new
task.due_at                      # => nil

# Date set
task.due_at_date = '2001-02-03'
task.due_at_date                 # => 2001-02-03 00:00:00 +0700
task.due_at_time                 # => 2001-02-03 00:00:00 +0700
task.due_at                      # => 2001-02-03 00:00:00 +0700

# Time set
task.due_at_time = '10:00pm'
task.due_at_time                 # => 2013-12-02 22:00:00 +0800
task.due_at_date                 # => 2001-02-03 00:00:00 +0700
task.due_at                      # => 2001-02-03 22:00:00 +0700

# Time zone is applied as set
task.due_at_time_zone = 'Moscow'
task.due_at                      # => Mon, 03 Feb 2013 22:00:00 MSK +04:00
task.due_at_time_zone = 'London'
task.due_at                      # => Mon, 03 Feb 2013 22:00:00 GMT +00:00
```

You can also use it with already existing/initialized attributes

```ruby
class Task
  include DateTimeAttribute

  attr_accessor :due_at
  date_time_attribute :due_at

  def initialize
    self.due_at = Time.zone.now.tomorrow
  end
end
```

## Using time zones

Default time zone can be applied to an attribute:

```ruby
class Task
  include DateTimeAttribute
  date_time_attribute :due_at, time_zone: 'Moscow'
end
```

```ruby
class Task
  include DateTimeAttribute
  date_time_attribute :due_at, time_zone: Proc.new { 'Moscow' }
end
```

```ruby
class Task
  include DateTimeAttribute
  date_time_attribute :due_at, time_zone: :my_time_zone

  def my_time_zone
    self.in_da_moscow? ? 'Moscow' : 'Birobidgan'
  end
end
```

You can also explicitly set timezone:

```ruby
Time.zone = 'Krasnoyarsk'
task.due_at                      # => nil
task.due_at_time = '02:00am'
task.due_at                      # => Mon, 02 Dec 2013 02:00:00 KRAT +08:00
task.due_at_time_zone = 'Moscow'
task.due_at                      # => Mon, 02 Dec 2013 02:00:00 MSK +04:00
```

## Rails users

You don't need to set up anything, it just works out of the box through railtie

```ruby
class MyModel < ActiveRecord::Base
  date_time_attribute :created_at
end
```

## ActiveRecord users (no Rails)

In order to include globally in your models:

```ruby
ActiveRecord::Base.send(:include, DateTimeAttribute)
```

Then add attributes into your models:

```ruby
class MyModel < ActiveRecord::Base
  date_time_attribute :created_at, :updated_at # See more examples above
end
```

## Using Chronic gem

```ruby
DateTimeAttribute.parser = Chronic

task.due_at_date = 'next saturday'
task.due_at_time = '10:00pm'
```

## Advanced usage

```ruby
my_date_time = DateTimeAttribute::Container.new
my_date_time.date_time           # => nil
my_date_time.date = '2001-02-03'
my_date_time.date_time           # => 2001-02-03 00:00:00 +0700
my_date_time.time = '10:00pm'
my_date_time.date_time           # => 2001-02-03 22:00:00 +0700

# ...same as described above

my_date_time = DateTimeAttribute::Container.new(Time.zone.now)
my_date_time.date_time # => 2013-12-03 00:02:01 +0000
```

