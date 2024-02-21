class FavoritoSerializer < ActiveModel::Serializer
  attributes :id, :favorito
  has_one :user
  has_one :libro
end
