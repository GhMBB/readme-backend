require 'test_helper'
class FavoritosControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @libro_id = libros(:one).id
    @token = JwtService.encode(@user)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

 test "should create favorito" do
  post :create, params: { libro_id: @libro_id, fav: true } 
  assert_response :created
end


  test "should update favorito if already exists" do
    favorito = Favorito.create(favorito:false,user_id:@user.id,libro_id:@libro_id)
    favorito.save!
    post :create, params: { libro_id: @libro_id, user_id: @user.id, fav: true } 
    favoritoActualizado = Favorito.find_by(id: favorito.id)
    assert_equal true, favoritoActualizado.favorito
    assert_response 201
  end

end
