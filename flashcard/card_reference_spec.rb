require 'spec_helper'

describe CardReference do

  after(:each) { Timecop.return }

  describe "a new card" do
    its(:score) { should be_zero }
    its(:expiration_date) { should == Date.today }
    it { should be_expired }
    it { should_not be_valid }
  end

  describe "#ask_next_on" do

    it "moves the expiration date to the future when you remember an expired card" do
      card = CardReference.new
      Timecop.travel 3.weeks.from_now
      card.remembered
      card.should_not be_expired
      card.expiration_date.should == Date.tomorrow
    end

    it "changes the expiration date according to the Fibonaci sequence" do
      card = CardReference.new

      [1, 2, 3, 5, 8, 13].each do |interval|
        expect { card.remembered }.to change { card.expiration_date }.by(interval)
        Timecop.travel card.expiration_date
      end
    end

    it "shouldn't shouldn't change when you remember a card that's not expired" do
      card = CardReference.new
      card.remembered
      card.should_not be_expired
      expect { card.remembered }.not_to change { card.expiration_date }
    end
  end
end
