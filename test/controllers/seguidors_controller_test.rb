require "test_helper"

class SeguidorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @seguidor = seguidors(:one)
  end

  test "should get index" do
    get seguidors_url, as: :json
    assert_response :success
  end

  test "should create seguidor" do
    assert_difference("Seguidor.count") do
      post seguidors_url, params: { seguidor: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show seguidor" do
    get seguidor_url(@seguidor), as: :json
    assert_response :success
  end

  test "should update seguidor" do
    patch seguidor_url(@seguidor), params: { seguidor: {  } }, as: :json
    assert_response :success
  end

  test "should destroy seguidor" do
    assert_difference("Seguidor.count", -1) do
      delete seguidor_url(@seguidor), as: :json
    end

    assert_response :no_content
  end
end
