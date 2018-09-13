require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  describe "new" do
    it 'gets new' do
      get new_user_url
      assert_response :success
    end
  end

  describe "create" do
    let(:user_name) { 'some name' }
    let(:params)    { {user: {name: user_name}} }

    describe 'with valid params' do
      it 'redirects to the user index page' do
        post users_url, params: params
        assert_redirected_to users_path
      end
    end

    describe 'with invalid params' do
      let(:user_name) { nil }
      it 'renders the sign-in page with a display of the errors' do
        post users_url, params: params
        assert_response :success
        assert_template :new
        expect(response.body).must_match /Errors<\/h5>/
      end
    end
  end
end
