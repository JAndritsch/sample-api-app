require 'rails_helper'

describe User do

  describe 'attributes' do
    it { is_expected.to respond_to(:username) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:auth_token) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username) }

    describe 'password_confirmation' do
      it 'requires password and password_confirmation to be equal' do
        user = described_class.new(username: 'joel', password: 'some pass')
        user.password_confirmation = 'blah'
        expect(user.save).to eql(false)
        expect(user.errors[:password_confirmation].count).to eql(1)
      end

      it 'does not require password and password_confirmation to be equal if the password did not change' do
        user = described_class.new(username: 'joel', password: 'some pass')
        user.password_confirmation = 'some pass'
        expect(user.save).to eql(true)
        user.password_confirmation = 'blah'
        expect(user.save).to eql(true)
      end
    end

  end
end
