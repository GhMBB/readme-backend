require "test_helper"

class SolicitudDesbaneosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solicitud_desbaneo = solicitud_desbaneos(:one)
  end

  test "should get index" do
    get solicitud_desbaneos_url, as: :json
    assert_response :success
  end

  test "should create solicitud_desbaneo" do
    assert_difference("SolicitudDesbaneo.count") do
      post solicitud_desbaneos_url, params: { solicitud_desbaneo: { baneado_id: @solicitud_desbaneo.baneado_id, estado: @solicitud_desbaneo.estado, justificacion: @solicitud_desbaneo.justificacion } }, as: :json
    end

    assert_response :created
  end

  test "should show solicitud_desbaneo" do
    get solicitud_desbaneo_url(@solicitud_desbaneo), as: :json
    assert_response :success
  end

  test "should update solicitud_desbaneo" do
    patch solicitud_desbaneo_url(@solicitud_desbaneo), params: { solicitud_desbaneo: { baneado_id: @solicitud_desbaneo.baneado_id, estado: @solicitud_desbaneo.estado, justificacion: @solicitud_desbaneo.justificacion } }, as: :json
    assert_response :success
  end

  test "should destroy solicitud_desbaneo" do
    assert_difference("SolicitudDesbaneo.count", -1) do
      delete solicitud_desbaneo_url(@solicitud_desbaneo), as: :json
    end

    assert_response :no_content
  end
end
