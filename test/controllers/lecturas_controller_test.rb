require "test_helper"

class LecturasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lectura = lecturas(:one)
  end

  test "should get index" do
    get lecturas_url, as: :json
    assert_response :success
  end

  test "should create lectura" do
    assert_difference("Lectura.count") do
      post lecturas_url, params: { lectura: { fecha: @lectura.fecha, libro_id: @lectura.libro_id, user_id: @lectura.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show lectura" do
    get lectura_url(@lectura), as: :json
    assert_response :success
  end

  test "should update lectura" do
    patch lectura_url(@lectura), params: { lectura: { fecha: @lectura.fecha, libro_id: @lectura.libro_id, user_id: @lectura.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy lectura" do
    assert_difference("Lectura.count", -1) do
      delete lectura_url(@lectura), as: :json
    end

    assert_response :no_content
  end
end
