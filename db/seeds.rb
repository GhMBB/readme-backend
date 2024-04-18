# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Encuentra y elimina los usuarios predeterminados si existen

# Crea 10 usuarios y moderadores

=begin

5.times do |i|
  defaultUsuario = User.find_by(username: "usuario_#{i}")
  defaultModerador = User.find_by(username: "moderador_#{i}")
  defaultUsuario.destroy! if defaultUsuario
  defaultModerador.destroy! if defaultModerador
  User.create(username: "usuario_#{i}", password: "ab123456", role: "usuario")
  User.create(username: "moderador_#{i}", password: "ab123456", role: "moderador")
end

moderadores = User.where(role: 'moderador')
moderadores.each do |moderador|
  Persona.create(user_id: moderador.id, fecha_de_nacimiento: '01/01/2000')
end
=end

=begin
# Crea 10 libros para cada usuario
User.all.each do |user|
  10.times do |i|
    Libro.create(titulo: "libro_#{i}", categoria: "historia", user_id: user.id)
    Libro.create(titulo: "libro_#{i}", categoria: "magia", user_id: user.id)
  end
end

# Crea 10 favoritos para cada usuario
User.all.each do |user|
  10.times do |i|
    Favorito.create(libro_id: i + 1, user_id: user.id, favorito: true)
  end
end
=end
# db/seeds.rb

# Cargar datos para categorías de reportes de usuarios

UserReportCategory.create([
                            { name: 'Comportamiento inapropiado' },
                            { name: 'Suplantación de identidad' },
                            { name: 'Publicación de contenido inapropiado' },
                            { name: 'Acoso' },
                            { name: 'Spam' },
                            { name: 'Otro' }
                          ])

# Cargar datos para categorías de reportes de libros
BookReportCategory.create([
                            { name: 'Contenido inapropiado' },
                            { name: 'Derechos de autor' },
                            { name: 'Calidad del contenido' },
                            { name: 'Contenido engañoso' },
                            { name: 'Spam' },
                            { name: 'Violación de políticas de la comunidad' },
                            { name: 'Otro' }
                          ])

# Cargar datos para categorías de reportes de comentarios
CommentReportCategory.create([
                               { name: 'Contenido inapropiado' },
                               { name: 'Acoso' },
                               { name: 'Spam' },
                               { name: 'Lenguaje ofensivo' },
                               { name: 'Incitación al odio' },
                               { name: 'Otro' }
                             ])


