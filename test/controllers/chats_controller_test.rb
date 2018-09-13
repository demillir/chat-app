require "test_helper"

class ChatsControllerTest < ActionDispatch::IntegrationTest
  before do
    sign_in
  end

  describe "show" do
    let(:partner_name) { "some partner" }
    let(:partner)      { User.new(name: partner_name) }

    before do
      ActiveUsers.instance << partner
    end

    it 'gets show' do
      get chat_url(partner_name)
      assert_response :success
    end
  end
end
