require 'test_helper'

describe ActiveUserDB do
  subject { ActiveUserDB.instance }

  before do
    # Start each test with an empty set.
    subject.clear
  end

  describe "<<" do
    it "accepts new users" do
      expect {
        subject << User.new(name: 'foo')
      }.must_change "subject.count"
    end

    it "ignores already-present users" do
      subject << User.new(name: 'foo')
      expect {
        subject << User.new(name: 'foo')
      }.must_change "subject.count", 0
    end
  end

  describe "delete" do
    it "removes present users" do
      subject << User.new(name: 'foo')
      expect {
        subject.delete User.new(name: 'foo')
      }.must_change "subject.count", -1
    end

    it "ignores unknown users" do
      subject << User.new(name: 'foo1')
      subject << User.new(name: 'foo2')
      expect {
        subject.delete User.new(name: 'foo')
      }.must_change "subject.count", 0
    end
  end

  describe "[]" do
    describe "an empty set" do
      it "returns nil" do
        expect(subject['some key']).must_be_nil
      end
    end

    describe "a non-empty set" do
      before do
        subject << User.new(name: 'foo1')
        subject << User.new(name: 'foo2')
      end

      it "does not yield anything" do
        expect(subject['foo1']&.name).must_equal 'foo1'
        expect(subject['foo2']&.name).must_equal 'foo2'
        expect(subject['foo3']&.name).must_be_nil
      end
    end

  end

  describe "each" do
    describe "an empty set" do
      it "does not yield anything" do
        i = 0
        subject.each { i += 1}
        expect(i).must_equal 0
      end
    end

    describe "a non-empty set" do
      before do
        subject << User.new(name: 'foo1')
        subject << User.new(name: 'foo2')
      end

      it "does not yield anything" do
        i = 0
        subject.each { i += 1}
        expect(i).must_equal 2
      end
    end
  end
end
