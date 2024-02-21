require "test_helper"

class TotalResenhasControllerTest < ActionDispatch::IntegrationTest
  setup do
    @total_resenha = total_resenhas(:one)
  end

  test "should get index" do
    get total_resenhas_url, as: :json
    assert_response :success
  end

  test "should create total_resenha" do
    assert_difference("TotalResenha.count") do
      post total_resenhas_url, params: { total_resenha: { cantidad: @total_resenha.cantidad, libro_id: @total_resenha.libro_id, media: @total_resenha.media, sumatoria: @total_resenha.sumatoria } }, as: :json
    end

    assert_response :created
  end

  test "should show total_resenha" do
    get total_resenha_url(@total_resenha), as: :json
    assert_response :success
  end

  test "should update total_resenha" do
    patch total_resenha_url(@total_resenha), params: { total_resenha: { cantidad: @total_resenha.cantidad, libro_id: @total_resenha.libro_id, media: @total_resenha.media, sumatoria: @total_resenha.sumatoria } }, as: :json
    assert_response :success
  end

  test "should destroy total_resenha" do
    assert_difference("TotalResenha.count", -1) do
      delete total_resenha_url(@total_resenha), as: :json
    end

    assert_response :no_content
  end
end
