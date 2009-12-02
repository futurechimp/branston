require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  
  def setup
    @release = Release.make
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:releases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create release" do
    assert_difference('Release.count') do
      post :create, :release =>  Release.plan 
    end

    assert_redirected_to release_path(assigns(:release))
  end

  test "should show release" do
    get :show, :id => @release.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @release.to_param
    assert_response :success
  end

  test "should update release" do
    put :update, :id => @release.to_param, :release => { }
    assert_redirected_to release_path(assigns(:release))
  end

  test "should destroy release" do
    assert_difference('Release.count', -1) do
      delete :destroy, :id => @release.to_param
    end

    assert_redirected_to releases_path
  end
end
