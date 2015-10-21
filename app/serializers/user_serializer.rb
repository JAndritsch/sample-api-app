class UserSerializer < ActiveModel::Serializer
  root false
  attributes :id, :username, :errors
end
