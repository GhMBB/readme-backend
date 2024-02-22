require "test_helper"

class FavoritosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @favorito = favoritos(:one)
  end

  #test "should get index" do
  #  get favoritos_url, as: :json
  #  assert_response :success
  #end

  test "should create favorito" do
    post favoritos_url, params: {fav: @favorito.favorito, libro_id: @favorito.libro_id, user_id: @favorito.user_id }, as: :json
    assert_response :created
  end

  #test "should show favorito" do
  #  get favorito_url(@favorito), as: :json
  #  assert_response :success
  #end

  test "should update favorito" do
    patch favorito_url(@favorito), params: { favorito: false }, as: :json
    assert_response :success
  end

  #test "should destroy favorito" do
  #  assert_difference("Favorito.count", -1) do
  #    delete favorito_url(@favorito), as: :json
  #  end

  #  assert_response :no_content
  #end
end
