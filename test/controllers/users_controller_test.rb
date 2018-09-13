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

      describe "with other users present" do
        before do
          IntroduceUser.call(user: User.new(name: "Other User 1"))
          IntroduceUser.call(user: User.new(name: "Other User 2"))
        end

        it "renders the other users' names" do
          get users_url
          expect(response.body).must_include "Other User 1"
          expect(response.body).must_include "Other User 2"
        end
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
      let(:introduction_result) { Interactor::Context.build }

      it 'redirects to the user index page' do
        post users_url, params: params
        assert_redirected_to users_path
      end

      it 'introduces the user' do
        mock = Minitest::Mock.new
        mock.expect :call, introduction_result, [Hash]

        IntroduceUser.stub :call, mock do
          post users_url, params: params
        end
        assert_mock mock
      end

      describe 'a failed introduction' do
        before do
          introduction_result.fail!(message: 'The Introduction Failed!') rescue nil
        end

        it 'renders the sign-in page with a display of the errors' do
          mock = Minitest::Mock.new
          mock.expect :call, introduction_result, [Hash]

          IntroduceUser.stub :call, mock do
            post users_url, params: params
          end
          assert_mock mock

          assert_response :success
          assert_template :new
          expect(response.body).must_match /The Introduction Failed/
        end
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

  describe "current_user" do
    before do
      # Start each test with an empty set of users.
      ActiveUserDB.instance.clear
    end

    describe "not yet signed in" do
      it "has no current user" do
        get users_url
        expect(controller.current_user).must_be_nil
      end
    end

    describe "after sign-in" do
      before do
        sign_in
      end

      it "has a current user" do
        get users_url
        expect(controller.current_user).must_be_kind_of User
      end
    end
  end
end
