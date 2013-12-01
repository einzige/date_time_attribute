require 'spec_helper'

describe DateTimeAttribute do
  before do
    Time.zone = 'Pacific Time (US & Canada)'
  end

  describe ".parser" do
    its(:parser) { should == Time.zone }
  end

  describe '.date_time_attribute' do
    let(:dummy_class) do
      Class.new do
        include DateTimeAttribute
        date_time_attribute :due_at, :created_at
      end
    end

    subject(:target) { dummy_class.new }

    it { should respond_to :due_at }
    it { should respond_to :due_at_time }
    it { should respond_to :due_at_date }
    it { should respond_to :created_at }
    it { should respond_to :created_at_time }
    it { should respond_to :created_at_date }

    describe "values" do
      let(:due_at) { nil }
      let(:time_zone) { nil }
      subject(:date_time) { target.due_at }

      before do
        target.due_at = due_at
        target.due_at_date = date
        target.due_at_time = time
        target.due_at_time_zone = time_zone
      end

      context "nothing set" do
        let(:due_at) { nil }
        let(:date) { nil }
        let(:time) { nil }

        it { should be_nil }
      end

      context "time set" do
        let(:date) { nil }
        let(:time) { '23:00' }

        its(:year) { should == Time.zone.now.year }
        its(:month) { should == Time.zone.now.month }
        its(:day) { should == Time.zone.now.day }
        its(:hour) { should == 23 }
      end

      context "date set" do
        let(:date) { '2001-02-03' }
        let(:time) { nil }

        its(:year) { should == 2001 }
        its(:month) { should == 2 }
        its(:day) { should == 3 }
        its(:hour) { should == 0 }

        context "time set" do
          let(:date) { '2001-02-03' }
          let(:time) { '10:00pm' }

          its(:year) { should == 2001 }
          its(:month) { should == 2 }
          its(:day) { should == 3 }
          its(:hour) { should == 22 }

          context "timezone set explicitly" do
            let(:time_zone) { 'Krasnoyarsk' }

            its(:year) { should == 2001 }
            its(:month) { should == 2 }
            its(:day) { should == 3 }
            its(:hour) { should == 22 }

            specify do
              subject.time_zone.name.should == 'Krasnoyarsk'
            end
          end

          context "time zone set on attribute" do
            let(:dummy_class) do
              Class.new do
                include DateTimeAttribute
                date_time_attribute :due_at, time_zone: 'Moscow'
              end
            end

            its(:year) { should == 2001 }
            its(:month) { should == 2 }
            its(:day) { should == 3 }
            its(:hour) { should == 22 }

            specify do
              subject.time_zone.name.should == 'Moscow'
            end

            context "timezone set explicitly" do
              let(:time_zone) { 'Krasnoyarsk' }

              its(:year) { should == 2001 }
              its(:month) { should == 2 }
              its(:day) { should == 3 }
              its(:hour) { should == 22 }

              specify do
                subject.time_zone.name.should == 'Krasnoyarsk'
              end
            end

            context "different timezone set" do
              before do
                Time.zone = 'Krasnoyarsk'
              end

              its(:year) { should == 2001 }
              its(:month) { should == 2 }
              its(:day) { should == 3 }
              its(:hour) { should == 22 }

              specify do
                subject.time_zone.name.should == 'Moscow'
              end
            end

            context "timezone proc given" do
              let(:dummy_class) do
                Class.new do
                  include DateTimeAttribute
                  date_time_attribute :due_at, time_zone: Proc.new { 'Moscow' }
                end
              end

              its(:year) { should == 2001 }
              its(:month) { should == 2 }
              its(:day) { should == 3 }
              its(:hour) { should == 22 }

              specify do
                subject.time_zone.name.should == 'Moscow'
              end
            end

            context "timezone method given" do
              let(:dummy_class) do
                Class.new do
                  include DateTimeAttribute
                  date_time_attribute :due_at, time_zone: :tz

                  def tz
                    'Moscow'
                  end
                end
              end

              its(:year) { should == 2001 }
              its(:month) { should == 2 }
              its(:day) { should == 3 }
              its(:hour) { should == 22 }

              specify do
                subject.time_zone.name.should == 'Moscow'
              end
            end

            context "nil timezone" do
              let(:dummy_class) do
                Class.new do
                  include DateTimeAttribute
                  date_time_attribute :due_at, time_zone: :tz

                  def tz
                    nil
                  end
                end
              end

              it { should be_a(Time) }
              its(:year) { should == 2001 }
              its(:month) { should == 2 }
              its(:day) { should == 3 }
              its(:hour) { should == 22 }
            end
          end
        end
      end
    end
  end
end
