require 'spec_helper'

describe DateTimeAttribute, ActiveRecord::Base, use_active_record: true do
  before do
    Time.zone = 'Pacific Time (US & Canada)'
  end

  context 'persisted record' do
    subject(:target) { Model.create! }

    it { should respond_to :created_at }
    it { should respond_to :created_at_time }
    it { should respond_to :created_at_date }

    describe 'values' do
      let(:created_at) { nil }
      let(:date) { nil }
      let(:time) { nil }
      let(:time_zone) { nil }
      subject(:date_time) { target.created_at }

      before do
        target.created_at = created_at
        target.created_at_date = date
        target.created_at_time = time
        target.created_at_time_zone = time_zone
      end

      context 'nothing set' do
        let(:created_at) { nil }
        let(:date) { nil }
        let(:time) { nil }

        it { should be_nil }
      end

      context 'date_time set' do
        let(:created_at) { Time.zone.now }
        it { should_not be_nil }
      end

      context 'date_time reset to nil' do
        let(:created_at) { nil }
        let(:date) { '2001-02-03' }
        let(:time) { '10:00pm' }

        it { should_not be_nil }

        context 'returning back to nil' do
          before do
            target.created_at = nil
            target.created_at_date = nil
          end

          it { should be_nil }
        end
      end

      context 'time set' do
        let(:date) { nil }
        let(:time) { '23:00' }

        its(:year) { should == Time.zone.now.year }
        its(:month) { should == Time.zone.now.month }
        its(:day) { should == Time.zone.now.day }
        its(:hour) { should == 23 }
      end

      context 'date set' do
        let(:date) { '2001-02-03' }
        let(:time) { nil }

        its(:year) { should == 2001 }
        its(:month) { should == 2 }
        its(:day) { should == 3 }
        its(:hour) { should == 0 }

        context 'time set' do
          let(:date) { '2001-02-03' }
          let(:time) { '10:00pm' }

          its(:year) { should == 2001 }
          its(:month) { should == 2 }
          its(:day) { should == 3 }
          its(:hour) { should == 22 }

          context 'timezone set explicitly' do
            let(:time_zone) { 'Krasnoyarsk' }

            its(:year) { should == 2001 }
            its(:month) { should == 2 }
            its(:day) { should == 3 }
            its(:hour) { should == 22 }

            specify do
              subject.time_zone.name.should == 'Krasnoyarsk'
            end
          end
        end
      end
    end
  end

  context "loaded from db" do
    subject { Model.find(Model.create!(created_at: '2014-01-01 12:00:00').id) }
    its(:created_at) { should == DateTime.new(2014, 01, 01, 12, 0, 0) }
  end
end
