require 'test_helper'

describe IntroduceUser do
  let(:user) { User.new(name: 'some name') }
  let(:set)  { Set.new }
  subject    { IntroduceUser.call(user: user, user_set: set) }

  describe ".call" do
    it "adds the user to the set" do
      expect{subject}.must_change "set.count"
      expect(set).must_include user
    end
  end
end
