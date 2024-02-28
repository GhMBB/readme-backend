require 'test_helper'

class CapitulosControllerTest < ActionController::TestCase
  setup do
    @libro = libros(:one)
    @capitulo = capitulos(:one)
    @user = users(:one)
    @token = JwtService.encode(@user)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get the capitulos of a libro successfully" do
    get :libro, params: { libro_id: @libro.id }
    assert_response :success, "Failed to retrieve capitulos of the libro"
  end

  test "should create capitulo successfully" do
    assert_difference('Capitulo.count') do
      post :create, params: { libro_id: @libro.id, titulo: "Nuevo Capitulo", contenido: "Contenido del nuevo capitulo" }
    end

    assert_response :created, "Failed to create the capitulo"
  end

  test "should not create capitulo without contenido" do
    assert_no_difference('Capitulo.count') do
      post :create, params: { libro_id: @libro.id, titulo: "Nuevo Capitulo" }
    end

    assert_response :unprocessable_entity, "Created capitulo without contenido, which should not be possible"
  end

  test "should update capitulo successfully" do
    patch :update, params: { id: @capitulo.id, titulo: "Capitulo Actualizado" }
    assert_response :success, "Failed to update the capitulo"
  end

  test "should not update capitulo with invalid params" do
    patch :update, params: { id: @capitulo.id, titulo: "" }
    assert_response :unprocessable_entity, "Updated the capitulo with invalid parameters, which should not be possible"
  end

  test "should delete capitulo successfully" do
    assert_difference('Capitulo.where(deleted: false).count', -1) do
      delete :destroy, params: { id: @capitulo.id }
    end
  
    assert @capitulo.reload.deleted, "Failed to mark the capitulo as deleted"
    assert_response :success, "Failed to delete the capitulo"
  end

  test "should swap capitulos successfully" do
    capitulo1 = capitulos(:one)
    capitulo2 = capitulos(:two)

    put :swap, params: { capitulo1_id: capitulo1.id, capitulo2_id: capitulo2.id }

    assert_response :success, "Failed to swap capitulos"
  end

end
