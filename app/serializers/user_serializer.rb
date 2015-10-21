class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :errors
end
