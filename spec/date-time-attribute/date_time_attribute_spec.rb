require 'spec_helper'

describe DateTimeAttribute do
  before :all do
    Time.zone = 'Pacific Time (US & Canada)'
  end

  describe ".parser" do
    its(:parser) { should == Time.zone }
  end

  describe ".parser=" do
    let(:parser) { double('parser') }

    context "parser set" do
      before do
        described_class.parser = parser
      end

      after do
        described_class.parser = Time.zone
      end

      its(:parser) { should == parser }

      it 'sets holders parser' do
        DateTimeAttribute::Holder.parser.should == parser
      end
    end
  end

  describe '.date_time_attribute' do
    let(:dummy_class) do
      Class.new do
        include DateTimeAttribute
        date_time_attribute :due_at
      end
    end

    subject(:target) { dummy_class.new }

    it { should respond_to :due_at }
    it { should respond_to :due_at_time }
    it { should respond_to :due_at_date }

    describe "values" do
      let(:due_at) { nil }
      subject(:date_time) { target.due_at }

      before do
        target.due_at = due_at
        target.due_at_date = date
        target.due_at_time = time
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
        end
      end
    end
  end
end
