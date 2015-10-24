require 'rails_helper'

describe UsersController, type: :request do

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
        post '/users', create_params
      }.to change(User, :count).by(1)
    end

    it 'responds with the created user' do
      post '/users', create_params
      expect(response.body).to eql(UserSerializer.new(User.last).to_json)
    end
  end

  describe 'GET index' do
    let!(:authorized_user) do
      user = User.create({
        username: 'testuser1',
        password: 'password', 
        password_confirmation: 'password'
      })
      user.generate_auth_token!
      user
    end

    let!(:some_other_user) do
      User.create({
        username: 'testuser2',
        password: 'password', 
        password_confirmation: 'password'
      })
    end

    context 'when authorized' do
      before do
        get '/users', {}, { 'Authorization' => "Token token=#{authorized_user.auth_token}" }
      end

      it 'returns an array of user objects as JSON' do
        expected_response = { "users" => User.all.map { |user| UserSerializer.new(user) } }.to_json
        expect(body).to eql(expected_response)
      end
    end

    context 'when not authorized' do
      before do
        get '/users', {}, { 'Authorization' => "Token token=bogus token" }
      end

      it 'returns unauthorized' do
        expect(response).to be_unauthorized
      end

      it 'returns an array of user objects as JSON' do
        expect(response.body).to be_blank
      end
    end
  end

  describe 'GET show' do
    let!(:authorized_user) do
      user = User.create({
        username: 'testuser1',
        password: 'password', 
        password_confirmation: 'password'
      })
      user.generate_auth_token!
      user
    end

    context 'when authorized' do
      it 'returns the user object as JSON' do
        get "/users/#{authorized_user.id}", {}, { 'Authorization' => "Token token=#{authorized_user.auth_token}" }
        expected_response = UserSerializer.new(authorized_user).to_json
        expect(body).to eql(expected_response)
      end

      it 'returns a 404 if the user could not be found' do
        get "/users/0", {}, { 'Authorization' => "Token token=#{authorized_user.auth_token}" }
        expect(response).to be_not_found
      end
    end

    context 'when not authorized' do
      before do
        get "/users/#{authorized_user.id}", {}, { 'Authorization' => "Token token=bogus token" }
      end

      it 'returns unauthorized' do
        expect(response).to be_unauthorized
      end

      it 'returns an array of user objects as JSON' do
        expect(response.body).to be_blank
      end
    end
  end

end
