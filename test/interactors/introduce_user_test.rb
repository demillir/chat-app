require 'test_helper'

describe IntroduceUser do
  let(:user) { User.new(name: 'some name') }
  let(:db)   { Hash.new }
  subject    { IntroduceUser.call(user: user, user_db: db) }

  describe ".call" do
    it "adds the user to the set" do
      expect{subject}.must_change "db.count"
      expect(db.values).must_include user
    end
  end
end
