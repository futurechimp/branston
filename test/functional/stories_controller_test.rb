require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create story" do
    assert_difference('Story.count') do
      post :create, :story => { }
    end

    assert_redirected_to story_path(assigns(:story))
  end

  test "should show story" do
    get :show, :id => stories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => stories(:one).to_param
    assert_response :success
  end

  test "should update story" do
    put :update, :id => stories(:one).to_param, :story => { }
    assert_redirected_to story_path(assigns(:story))
  end

  test "should destroy story" do
    assert_difference('Story.count', -1) do
      delete :destroy, :id => stories(:one).to_param
    end

    assert_redirected_to stories_path
  end
end
