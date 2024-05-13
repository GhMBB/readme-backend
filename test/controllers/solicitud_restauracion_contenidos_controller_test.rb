require "test_helper"

class SolicitudRestauracionContenidosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solicitud_restauracion_contenido = solicitud_restauracion_contenidos(:one)
  end

  test "should get index" do
    get solicitud_restauracion_contenidos_url, as: :json
    assert_response :success
  end

  test "should create solicitud_restauracion_contenido" do
    assert_difference("SolicitudRestauracionContenido.count") do
      post solicitud_restauracion_contenidos_url, params: { solicitud_restauracion_contenido: { comentario_id: @solicitud_restauracion_contenido.comentario_id, deleted: @solicitud_restauracion_contenido.deleted, estado: @solicitud_restauracion_contenido.estado, libro_id: @solicitud_restauracion_contenido.libro_id, moderador_id: @solicitud_restauracion_contenido.moderador_id, reportado_id: @solicitud_restauracion_contenido.reportado_id } }, as: :json
    end

    assert_response :created
  end

  test "should show solicitud_restauracion_contenido" do
    get solicitud_restauracion_contenido_url(@solicitud_restauracion_contenido), as: :json
    assert_response :success
  end

  test "should update solicitud_restauracion_contenido" do
    patch solicitud_restauracion_contenido_url(@solicitud_restauracion_contenido), params: { solicitud_restauracion_contenido: { comentario_id: @solicitud_restauracion_contenido.comentario_id, deleted: @solicitud_restauracion_contenido.deleted, estado: @solicitud_restauracion_contenido.estado, libro_id: @solicitud_restauracion_contenido.libro_id, moderador_id: @solicitud_restauracion_contenido.moderador_id, reportado_id: @solicitud_restauracion_contenido.reportado_id } }, as: :json
    assert_response :success
  end

  test "should destroy solicitud_restauracion_contenido" do
    assert_difference("SolicitudRestauracionContenido.count", -1) do
      delete solicitud_restauracion_contenido_url(@solicitud_restauracion_contenido), as: :json
    end

    assert_response :no_content
  end
end
