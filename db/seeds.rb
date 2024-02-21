# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
defaultComprador = User.find_by(username: "comprador")
defaultVendedor = User.find_by(username: "vendedor")
defaultComprador.destroy! if !defaultComprador.nil?
defaultVendedor.destroy! if !defaultVendedor.nil?
User.create(username:"comprador",password:"123456",role:"comprador")
User.create(username:"vendedor",password:"123456",role:"vendedor")
