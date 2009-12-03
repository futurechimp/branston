require 'test_helper'

class PreconditionsControllerTest < ActionController::TestCase

  context "The PreconditionsController" do
    setup do
      @precondition = Precondition.make
    end

    should "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:preconditions)
    end

    should "should get new" do
      get :new
      assert_response :success
    end

    should "should create precondition" do
      assert_difference('Precondition.count') do
        post :create, :precondition => { }
      end

      assert_redirected_to precondition_path(assigns(:precondition))
    end

    should "should show precondition" do
      get :show, :id => @precondition.to_param
      assert_response :success
    end

    should "should get edit" do
      get :edit, :id => @precondition.to_param
      assert_response :success
    end

    should "should update precondition" do
      put :update, :id => @precondition.to_param, :precondition => { }
      assert_redirected_to precondition_path(assigns(:precondition))
    end

    should "should destroy precondition" do
      assert_difference('Precondition.count', -1) do
        delete :destroy, :id => @precondition.to_param
      end

      assert_redirected_to preconditions_path
    end
  end
end

