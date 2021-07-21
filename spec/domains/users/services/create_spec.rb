require 'rails_helper'

RSpec.describe "Users::Services::Create", type: :request do
  describe '.run' do
    context 'with valid params' do
      before do
        @params = {
          name: Faker::Name.name, 
          email: Faker::Internet.email,
          password: Faker::Internet.password
        }

        @status, @user = Users::Services::Create.run(@params)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should create new user' do
        expect(@user.persisted?).to eq(true)
        expect(@user.name).to eq(@params[:name])
        expect(@user.email).to eq(@params[:email])
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

        @status, _ = Users::Services::Create.run(params)
      end

      it 'status should be :registered' do
        expect(@status).to eq(:registered)
      end
    end

    context 'with invalid params' do
      before do
        params = {
          name: Faker::Name.name, 
          password: Faker::Internet.password
        }

        @status, @user = Users::Services::Create.run(params)
      end

      it 'status should be :unprocessable_entity' do
        expect(@status).to eq(:unprocessable_entity)
      end
    end
  end
end
