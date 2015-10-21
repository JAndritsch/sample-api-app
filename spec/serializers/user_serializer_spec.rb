require 'rails_helper'

describe UserSerializer do

  subject { described_class.new(User.new).attributes }

  it { is_expected.to include(:id) }
  it { is_expected.to include(:username) }
  it { is_expected.to include(:errors) }
end
