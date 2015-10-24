require 'rails_helper'

describe UserAuthenticator do

  let(:encrypted_pass) { Digest::MD5.hexdigest('password' + 'some salt') }
  let(:user) { User.new(username: 'user', password: encrypted_pass, salt: 'some salt') }

  let(:auth) { described_class.new(user) }


  describe '#valid_password?' do
    it 'returns true when provided the correct password' do
      expect(auth.valid_password?('password')).to eql(true)
    end

    it 'returns false when provided an incorrect password' do
      expect(auth.valid_password?('testing')).to eql(false)
    end
  end

  describe '#encrypted_password' do
    it 'combines the plaintext password with the salt and hashes it using MD5' do
      expect(auth.encrypted_password('password')).to eql(encrypted_pass)
    end
  end

end
