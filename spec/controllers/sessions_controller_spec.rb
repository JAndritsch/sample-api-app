require 'rails_helper'

describe SessionsController, type: :request do

  describe 'POST create' do

    let!(:user) do
      User.create({
        username: 'testuser',
        password: 'super awesome pass',
        password_confirmation: 'super awesome pass'
      })
    end

    context 'when provided valid credentials' do
      before do
        post '/sessions', username: 'testuser', password: 'super awesome pass'
      end

      it 'responds with a 201 status' do
        expect(response).to be_created
      end

      it 'generates an auth token for the user' do
        expect(user.reload.auth_token).to_not be_nil
      end

      it 'responds with an auth token for that user' do
        expected_token = user.reload.auth_token
        expect(JSON.parse(response.body)['auth_token']).to eql(expected_token)
      end
    end

    context 'when provided invalid credentials' do
      before do
        post '/sessions', username: 'testuser', password: 'incorrect password'
      end

      it 'responds with a 401 status' do
        expect(response).to be_unauthorized
      end

      it 'does not authenticate the user' do
        expect(user.reload.auth_token).to be_nil
      end
    end
  end

  describe 'DELETE destroy' do
    let!(:user) do
      user = User.create({
        username: 'testuser',
        password: 'super awesome pass',
        password_confirmation: 'super awesome pass'
      })
      user.generate_auth_token!
      user
    end

    context 'when provided a valid auth token' do
      before do
        delete '/sessions', {}, { 'Authorization' => "Token token=#{user.auth_token}" }
      end

      it "removes the user's auth token" do
        expect(user.reload.auth_token).to be_nil
      end

      it 'responds with no content' do
        expect(response.status).to eql(204)
      end
    end

    context 'when not provided with a valud auth token' do
      before do
        delete '/sessions', {}, { 'Authorization' => "Token token=invalidtoken" }
      end

      it "does not remove the user's auth token" do
        expect(user.reload.auth_token).to_not be_nil
      end

      it "responds with no content" do
        expect(response.status).to eql(204)
      end
    end
  end

end
