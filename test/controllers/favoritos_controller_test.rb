require 'test_helper'
class FavoritosControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    @libro_id = libros(:one).id
    @token = JwtService.encode(@user)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

 test "should create favorito" do
  post :create, params: { favorito: { libro_id: @libro_id, user_id: @user.id, fav: true } }
  assert_response :created
end


  test "should update favorito if already exists" do
    favorito = Favorito.create(libro_id: @libro_id, user_id: @user.id, fav: false)
    post :create, params: { favorito: { libro_id: @libro_id, user_id: @user.id, fav: true } }
    favorito.find_by(libro_id: @libro_id, user_id: @user.id)
    assert_equal true, favorito.fav
    assert_response :ok
  end

  test "should return error if user not found" do
    post :create, params: { favorito: { libro_id: @libro_id, user_id: "non_existing_id", fav: true  }}
    assert_response :bad_request
  end
end
