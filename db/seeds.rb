# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
defaultUsuario = User.find_by(username: "usuario")
defaultModerador = User.find_by(username: "moderador")
defaultUsuario.destroy! if !defaultUsuario.nil?
defaultModerador.destroy! if !defaultModerador.nil?
User.create(username:"usuario",password:"ab123456",role:"usuario")
User.create(username:"moderador",password:"ab123456",role:"moderador")
Libro.create(titulo: "libro", categoria: "historia",user_id: 1)
Libro.create(titulo: "libro", categoria: "magia",user_id: 1)
Favorito.create(libro_id: 1, user_id: 1, favorito: true)
Favorito.create(libro_id: 2, user_id: 1, favorito: true)
