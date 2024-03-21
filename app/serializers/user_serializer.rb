class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role, :profile, :fecha_de_nacimiento

  def profile
    object.persona.profile if object.persona
  end
  def fecha_de_nacimiento
    object.persona.fecha_de_nacimiento if object.persona
  end
end
