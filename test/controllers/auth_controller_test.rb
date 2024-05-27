# test/controllers/auth_controller_test.rb
require 'test_helper'

class AuthControllerTest < ActionDispatch::IntegrationTest

  test 'should not log in with invalid credentials' do
    post login_url, params: { username: 'non_existent_user', password: 'wrong_password' }
    assert_response :unauthorized
    json_response = JSON.parse(response.body)
    assert json_response.key?('error')
  end

test 'should register with valid parameters' do
  post register_url, params: {
    username: 'administrador',
    password: 'ab123456',
    email: 'admin2@readme.com',
    password_confirmation: 'ab123456',
    role: 'usuario',
    fecha_nacimiento: '2000-01-01'
  }
  assert_response :success
  json_response = JSON.parse(response.body)
  assert json_response.key?('token')
  assert json_response.key?('expiration')
  assert json_response.key?('username')
  assert json_response.key?('role')
  assert json_response.key?('user_id')

end


  test 'should not register with invalid parameters' do
    post register_url, params: { username: '', password: 'password', password_confirmation: 'password', role: 'invalid_role' }
    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert json_response.key?('error')
  end

   test 'should log in with valid credentials' do
    @user = users(:one) # Assuming you have a fixture or create the user in the setup
    post login_url, params: { username: 'user1', password: 'password123' }
    assert_response :success
    json_response = JSON.parse(response.body)
    assert json_response.key?('token')
    assert json_response.key?('expiration')
    assert json_response.key?('username')
    assert json_response.key?('role')
  end

end
