require 'rails_helper'

describe User do

  let(:valid_user) do
    user = described_class.new(username: 'joel', password: 'some pass')
    user.password_confirmation = 'some pass'
    user
  end

  subject { valid_user }

  describe 'attributes' do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:auth_token) }
    it { is_expected.to respond_to(:salt) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username) }
    it { is_expected.to validate_uniqueness_of(:auth_token) }
    it { is_expected.to validate_uniqueness_of(:salt) }

    describe 'password_confirmation' do
      it 'requires password and password_confirmation to be equal' do
        valid_user.password_confirmation = 'blah'
        expect(valid_user.save).to eql(false)
        expect(valid_user.errors[:password_confirmation].count).to eql(1)
      end

      it 'does not require password and password_confirmation to be equal if the password did not change' do
        expect(valid_user.save).to eql(true)
        valid_user.password_confirmation = 'blah'
        expect(valid_user.save).to eql(true)
      end
    end
  end

  describe 'before create' do
    let(:user) do
      user = described_class.new(username: 'joel', password: 'some pass')
      user.password_confirmation = 'some pass'
      user
    end

    it 'generates a salt' do
      expect(valid_user.salt).to be_nil
      valid_user.save
      expect(valid_user.salt).to_not be_nil
    end
  end

  describe '#generate_auth_token!' do
    it 'creates a new authentication token and saves it' do
      expect(valid_user.auth_token).to be_nil
      valid_user.generate_auth_token!
      expect(valid_user.auth_token).to_not be_nil
    end
  end

  describe '#remove_auth_token!' do
    it 'nils out the auth token' do
      valid_user.auth_token = 'some auth token'
      valid_user.save
      expect(valid_user.auth_token).to_not be_nil
      valid_user.remove_auth_token!
      expect(valid_user.auth_token).to be_nil
    end
  end

end
