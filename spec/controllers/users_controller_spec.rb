require 'rails_helper'

describe UsersController do
  describe 'POST create' do

    let(:create_params) do
      {
        user: {
          username: 'bob',
          password: 'encrypted_password',
          password_confirmation: 'encrypted_password'
        }
      }
    end

    it 'creates a new user' do
      expect {
        post :create, create_params
      }.to change(User, :count).by(1)
    end

    it 'responds with the created user' do
      post :create, create_params
      expect(response.body).to eql(UserSerializer.new(User.last).to_json)
    end

  end
end
