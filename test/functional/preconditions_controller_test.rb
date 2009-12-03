require 'test_helper'

class PreconditionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:preconditions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create precondition" do
    assert_difference('Precondition.count') do
      post :create, :precondition => { }
    end

    assert_redirected_to precondition_path(assigns(:precondition))
  end

  test "should show precondition" do
    get :show, :id => preconditions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => preconditions(:one).to_param
    assert_response :success
  end

  test "should update precondition" do
    put :update, :id => preconditions(:one).to_param, :precondition => { }
    assert_redirected_to precondition_path(assigns(:precondition))
  end

  test "should destroy precondition" do
    assert_difference('Precondition.count', -1) do
      delete :destroy, :id => preconditions(:one).to_param
    end

    assert_redirected_to preconditions_path
  end
end
