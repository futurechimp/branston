require 'test_helper'

class OutcomesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:outcomes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create outcome" do
    assert_difference('Outcome.count') do
      post :create, :outcome => { }
    end

    assert_redirected_to outcome_path(assigns(:outcome))
  end

  test "should show outcome" do
    get :show, :id => outcomes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => outcomes(:one).to_param
    assert_response :success
  end

  test "should update outcome" do
    put :update, :id => outcomes(:one).to_param, :outcome => { }
    assert_redirected_to outcome_path(assigns(:outcome))
  end

  test "should destroy outcome" do
    assert_difference('Outcome.count', -1) do
      delete :destroy, :id => outcomes(:one).to_param
    end

    assert_redirected_to outcomes_path
  end
end
