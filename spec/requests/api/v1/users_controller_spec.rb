require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /register" do
    context 'with valid params' do
      before do
        @params = {
          name: Faker::Name.name, 
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }

        post api_v1_register_path, params: @params
      end

      it 'response status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should return user data' do
        user = User.last

        expectation = {
          user: {
            id: user.id,
            name: user.name,
            email: user.email,
            status: user.status
          }
        }.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end

    context 'with registered email' do
      before do
        email = Faker::Internet.email

        params = {
          name: Faker::Name.name, 
          email: email,
          password: Faker::Internet.password
        }

        create(:user, email: email)

        post api_v1_register_path, params: params
      end

      it 'response status should be 422' do
        expect(response.status).to eq(422)
      end

      it 'should has error message' do
        expectation = {
          success: false,
          message: "Email is already registered, please enter another email address."
        }.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end

    context 'with invalid params' do
      before do
        params = {
          name: Faker::Name.name, 
          password: Faker::Internet.password
        }

        post api_v1_register_path, params: params
      end

      it 'response status should be 422' do
        expect(response.status).to eq(422)
      end

      it 'should has error message' do
        expectation = {
          success: false,
          message: "Email can't be blank"
        }
      end
    end
  end
end
