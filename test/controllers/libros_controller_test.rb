require 'test_helper'

class LibrosControllerTest < ActionController::TestCase
  setup do
    @libro = libros(:one) # Suponiendo que tienes fixtures configurados correctamente
  end

  test "should get the libro" do
    get :show, params: { id: @libro.id }
    assert_response :success

    libro_serializado = LibroSerializer.new(@libro).as_json
    response_body = JSON.parse(response.body)

    assert_equal libro_serializado["id"], response_body["id"]
    assert_equal libro_serializado["titulo"], response_body["titulo"]
    assert_equal libro_serializado["sinopsis"], response_body["sinopsis"]
    assert_equal libro_serializado["adulto"], response_body["adulto"]
    assert_equal libro_serializado["cantidad_lecturas"], response_body["cantidad_lecturas"]
    assert_equal libro_serializado["cantidad_resenhas"], response_body["cantidad_resenhas"]
    assert_equal libro_serializado["puntuacion_media"], response_body["puntuacion_media"]
    assert_equal libro_serializado["cantidad_comentarios"], response_body["cantidad_comentarios"]
    assert_equal libro_serializado["categoria"], response_body["categoria"]
    assert_equal libro_serializado["user_id"], response_body["user_id"]
  end
end
