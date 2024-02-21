require "test_helper"

class ResenhasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @resenha = resenhas(:one)
  end

  test "should get index" do
    get resenhas_url, as: :json
    assert_response :success
  end

  test "should create resenha" do
    assert_difference("Resenha.count") do
      post resenhas_url, params: { resenha: { libro_id: @resenha.libro_id, puntuacion: @resenha.puntuacion, user_id: @resenha.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show resenha" do
    get resenha_url(@resenha), as: :json
    assert_response :success
  end

  test "should update resenha" do
    patch resenha_url(@resenha), params: { resenha: { libro_id: @resenha.libro_id, puntuacion: @resenha.puntuacion, user_id: @resenha.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy resenha" do
    assert_difference("Resenha.count", -1) do
      delete resenha_url(@resenha), as: :json
    end

    assert_response :no_content
  end
end
