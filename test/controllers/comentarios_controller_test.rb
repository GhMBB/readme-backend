require "test_helper"

class ComentariosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @comentario = comentarios(:one)
  end

  test "should get index" do
    get comentarios_url, as: :json
    assert_response :success
  end

  test "should create comentario" do
    assert_difference("Comentario.count") do
      post comentarios_url, params: { comentario: { comentario: @comentario.comentario, libro_id: @comentario.libro_id, user_id: @comentario.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show comentario" do
    get comentario_url(@comentario), as: :json
    assert_response :success
  end

  test "should update comentario" do
    patch comentario_url(@comentario), params: { comentario: { comentario: @comentario.comentario, libro_id: @comentario.libro_id, user_id: @comentario.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy comentario" do
    assert_difference("Comentario.count", -1) do
      delete comentario_url(@comentario), as: :json
    end

    assert_response :no_content
  end
end
