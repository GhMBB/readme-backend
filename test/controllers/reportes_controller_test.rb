require "test_helper"

class ReportesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @reporte = reportes(:one)
  end

  test "should get index" do
    get reportes_url, as: :json
    assert_response :success
  end

  test "should create reporte" do
    assert_difference("Reporte.count") do
      post reportes_url, params: { reporte: { estado: @reporte.estado, libro_id: @reporte.libro_id, motivo: @reporte.motivo, user_id: @reporte.user_id } }, as: :json
    end

    assert_response :created
  end

  test "should show reporte" do
    get reporte_url(@reporte), as: :json
    assert_response :success
  end

  test "should update reporte" do
    patch reporte_url(@reporte), params: { reporte: { estado: @reporte.estado, libro_id: @reporte.libro_id, motivo: @reporte.motivo, user_id: @reporte.user_id } }, as: :json
    assert_response :success
  end

  test "should destroy reporte" do
    assert_difference("Reporte.count", -1) do
      delete reporte_url(@reporte), as: :json
    end

    assert_response :no_content
  end
end
