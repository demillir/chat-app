require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  describe "index" do
    describe "before signing in" do
      it 'redirects to the sign-in page' do
        get users_url
        assert_redirected_to new_user_path
      end
    end

    describe "after signing in" do
      before do
        sign_in
      end

      it 'renders the index page' do
        get users_url
        assert_response :success
        assert_template :index
      end
    end
  end

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
