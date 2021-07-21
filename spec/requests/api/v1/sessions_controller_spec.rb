require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /login" do
    context 'with valid params' do
      before do
        email = Faker::Internet.email
        password = Faker::Internet.password

        @user = create(:user, email: email, password: password)

        params = {
          email: email,
          password: password
        }

        post api_v1_login_path, params: params
      end

      it 'response status should be 200' do
        expect(response.status).to eq(200)
      end
    end

    context 'with invalid password' do
      before do
        email = Faker::Internet.email
        password = Faker::Internet.password

        @user = create(:user, email: email, password: password)

        params = {
          email: email,
          password: 'abcdefghi'
        }

        post api_v1_login_path, params: params
      end

      it 'response status should be 422' do
        expect(response.status).to eq(422)
      end

      it 'should has error message' do
        expectation = {
          message: "The email address or password you entered is incorrect."
        }.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end
  end
end
