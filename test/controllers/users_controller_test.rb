require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  describe "new" do
    it 'gets new' do
      get new_user_url
      assert_response :success
    end
  end
end
