require "test_helper"

class CapitulosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @capitulo = capitulos(:one)
  end

  test "should get index" do
    get capitulos_url, as: :json
    assert_response :success
  end

  test "should create capitulo" do
    assert_difference("Capitulo.count") do
      post capitulos_url, params: { capitulo: { libro_id: @capitulo.libro_id, nombre_archivo: @capitulo.nombre_archivo, titulo: @capitulo.titulo } }, as: :json
    end

    assert_response :created
  end

  test "should show capitulo" do
    get capitulo_url(@capitulo), as: :json
    assert_response :success
  end

  test "should update capitulo" do
    patch capitulo_url(@capitulo), params: { capitulo: { libro_id: @capitulo.libro_id, nombre_archivo: @capitulo.nombre_archivo, titulo: @capitulo.titulo } }, as: :json
    assert_response :success
  end

  test "should destroy capitulo" do
    assert_difference("Capitulo.count", -1) do
      delete capitulo_url(@capitulo), as: :json
    end

    assert_response :no_content
  end
end
