require 'rails_helper'

describe SessionsController do

  let(:user) do 
    instance_double('User', { 
      generate_auth_token!: nil,
      auth_token: 'auth token',
      username: 'someuser',
    })
  end

  describe '#create' do
    let(:authenticator) { instance_double('UserAuthenticator') }

    before do
      allow(User).to receive(:find_by).with(username: user.username).and_return(user)
      allow(UserAuthenticator).to receive(:new).with(user).and_return(authenticator)
    end

    context 'when provided valid credentials' do
      before do
        allow(authenticator).to receive(:valid_password?).with('correct password').and_return(true)
        post :create, username: user.username, password: 'correct password', format: :json
      end

      it 'generates an auth token' do
        expect(user).to have_received(:generate_auth_token!)
      end

      it 'returns an auth token' do
        expect(JSON.parse(response.body)['auth_token']).to eql('auth token')
      end
    end

    context 'when provided invalid credentials' do
      before do
        allow(authenticator).to receive(:valid_password?).with('incorrect pass').and_return(false)
        post :create, username: user.username, password: 'incorrect pass', format: :json
      end

      it 'does not generate an auth token' do
        expect(user).to_not have_received(:generate_auth_token!)
      end

      it 'returns an "unauthorized" status' do
        expect(response).to be_unauthorized
      end
    end
  end

end
