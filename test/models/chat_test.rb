require 'test_helper'

describe Chat do
  let(:initiator) { User.new(name: "initiator name") }
  let(:partner)   { User.new(name: "partner name") }
  subject         { Chat.new(initiator: initiator, partner: partner) }

  it { expect(subject).must_be :valid? }

  describe "without an initiator" do
    let(:initiator) { nil }

    it { expect(subject).wont_be :valid? }
  end

  describe "without a partner" do
    let(:partner) { nil }

    it { expect(subject).wont_be :valid? }
  end

  describe ".id" do
    it "returns an array of strings" do
      expect(subject.id).must_be_kind_of Array
      expect(subject.id.all? {|s| s.is_a?(String)}).must_equal true
    end
  end
end
