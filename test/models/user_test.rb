require 'test_helper'

describe User do
  let(:user_name) { "name" }
  subject         { User.new(name: user_name) }

  it { expect(subject).must_be :valid? }

  describe "without a name" do
    let(:user_name) { nil }

    it { expect(subject).wont_be :valid? }
  end
end
