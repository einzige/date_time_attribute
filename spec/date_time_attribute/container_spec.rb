require 'spec_helper'

describe DateTimeAttribute::Container do
  subject { described_class.new(Time.now) }

  its(:year) { should == Time.now.year }
  its(:month) { should == Time.now.month }
  its(:day) { should == Time.now.day }
  its(:hour) { should == Time.now.hour }

  describe 'setters' do
    before do
      Time.zone = 'Pacific Time (US & Canada)'
    end

    subject(:target) { described_class.new(date_time, date, time) }

    let(:date_time) { nil }

    before do
      target.date_time = date_time
      target.date = date
      target.time = time
    end

    context "nothing set" do
      let(:date_time) { nil }
      let(:date) { nil }
      let(:time) { nil }

      its(:date_time) { should be_nil }
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

      it 'does not use current timezone' do
        subject.hour.should == 0
      end

      context "time set" do
        let(:date) { '2001-02-03' }
        let(:time) { '10:00pm' }

        its(:year) { should == 2001 }
        its(:month) { should == 2 }
        its(:day) { should == 3 }
        its(:hour) { should == 22 }

        context "non string values" do
          let(:date) { Date.new(2001, 02, 03) }
          let(:time) { Time.new(2001, 02, 03, 04, 05) }

          its(:year) { should == 2001 }
          its(:month) { should == 2 }
          its(:day) { should == 3 }
          its(:hour) { should == 4 }
        end

        context "time zone set" do
          its(:year) { should == 2001 }
          its(:month) { should == 2 }

          specify do
            expect { subject.time_zone = 'Moscow' }.to change { subject.time_zone }.from(nil).to('Moscow')
          end

          specify do
            expect { subject.time_zone = 'Moscow' }.to change { subject.day }.from(3).to(4)
          end

          specify do
            expect { subject.time_zone = 'Moscow' }.to change { subject.hour }.from(22).to(9)
          end

          context "different environment timezone set" do
            before do
              Time.zone = 'Krasnoyarsk'
            end

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
