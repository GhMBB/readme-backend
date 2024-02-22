class FavoritoSerializer < ActiveModel::Serializer
  attributes :id, :favorito, :user_id, :libro_id

  #attribute :user_id, key: :user
  #attribute :libro_id, key: :libro
  #has_one :user
  #has_one :libro
end
