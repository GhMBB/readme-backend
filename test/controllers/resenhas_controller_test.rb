# test/controllers/resenhas_controller_test.rb
require 'test_helper'

class ResenhasControllerTest < ActionController::TestCase
  setup do
    @user = users(:one) # Ajusta esto según tus fixtures
    @resenha = resenhas(:one) # Ajusta esto según tus fixtures
    @token = JwtService.encode(@user)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should destroy resenha" do
    delete :destroy, params: { id: @resenha.id }
    assert_response :success
    assert_nil Resenha.find_by(id: @resenha.id, deleted: false)
  end

  test "should not destroy resenha if user cannot delete" do
    user_without_permission = users(:two) # Ajusta esto según tus fixtures
    @token = JwtService.encode(user_without_permission)
    @request.headers["Authorization"] = "Bearer #{@token}"
    delete :destroy, params: { id: @resenha.id, user_id: user_without_permission.id }
    assert_response :forbidden
  end

  test "should create resenha" do
    libro = libros(:one) # Ajusta esto según tus fixtures
    post :create_or_update, params: { user_id: @user.id, libro_id: libro.id, puntuacion: 4 }
    assert_response :created
    assert_not_nil Resenha.find_by(user_id: @user.id, libro_id: libro.id)
  end

  test "should update resenha" do
    put :create_or_update, params: { user_id: @user.id, libro_id: @resenha.libro_id, puntuacion: 5 }
    assert_response :success
    @resenha.reload
    assert_equal 5, @resenha.puntuacion
  end

  test "should find resenha by user and libro" do
    get :find_by_user_and_libro, params: { user_id: @user.id, libro_id: @resenha.libro_id }
    assert_response :success
    assert_equal @resenha, assigns(:resenha)
  end

  test "should not find resenha if not exists" do
    get :find_by_user_and_libro, params: { user_id: @user.id, libro_id: "non_existing_id" }
    assert_response :not_found
  end
end
