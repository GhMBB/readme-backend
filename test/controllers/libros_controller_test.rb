require 'test_helper'

class LibrosControllerTest < ActionController::TestCase
  setup do
    @libro = libros(:one)
    @user = users(:one)
    @token = JwtService.encode(@user)
    @request.headers["Authorization"] = "Bearer #{@token}"
  end

  test "should get the libro successfully" do
    get :show, params: { id: @libro.id }
    assert_response :success, "La solicitud para obtener el libro no fue exitosa"
  end

  test "should create libro successfully" do
    assert_difference('Libro.count') do
      post :create, params: { titulo: "Nuevo Libro", sinopsis: "Sinopsis del nuevo libro", adulto: false, categoria: "Romance" }
    end

    assert_response :created, "La solicitud para crear el libro no fue exitosa"
  end

  test "should not create libro without titulo" do
    assert_no_difference('Libro.count') do
      post :create, params: { sinopsis: "Sinopsis del nuevo libro", adulto: false, categoria: "Romance"}
    end
  end

test "should update libro successfully" do
  put :update, params: { id: @libro.id, titulo: "Libro Actualizado" }
  assert_response 200, "La solicitud para actualizar el libro no fue exitosa #{response.body}"
end


  test "should not update libro with invalid params" do
    patch :update, params: { id: @libro.id, titulo: "" }
    assert_response :unprocessable_entity, "Se actualizó el libro con parámetros inválidos, lo cual no debería ser posible"
  end

  test "should destroy libro successfully" do
    assert_difference('Libro.where(deleted: true).count', 1) do
      delete :destroy, params: { id: @libro.id }
    end
  
    assert @libro.reload.deleted, "El libro no se marcó como eliminado correctamente"
    assert_response :success, "La solicitud para eliminar el libro no fue exitosa"
  end
  
end
