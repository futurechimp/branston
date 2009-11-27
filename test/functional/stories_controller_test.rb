require 'test_helper'

class StoriesControllerTest < ActionController::TestCase

  context "The StoriesController" do
    setup do
      @story = Story.make
    end

    should "get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:stories)
    end

    should "get edit" do
      get :edit, :id => @story.to_param
      assert_response :success
    end

    should "get new" do
      get :new
      assert_response :success
    end

    should "show" do
      get :show, :id => @story.to_param
      assert_response :success
    end

    should "destroy story" do
      assert_difference('Story.count', -1) do
        delete :destroy, :id => @story.to_param
      end

      assert_redirected_to stories_path
    end

    context "creating a story" do

      context "with valid params" do
        setup do
          assert_difference("Story.count") do
            post :create, :story => Story.plan
          end
        end

        should "redirect to show" do
          assert_redirected_to story_path(assigns(:story))
        end
      end

      context "with invalid params" do
        setup do
          assert_no_difference("Story.count") do
            post :create, :story => {}
          end
        end

        should "redisplay" do
          assert_template 'new'
        end
      end
    end

    context "updating a story" do
      context "with valid parameters" do
        setup do
          assert_no_difference("Story.count") do
            put :update,{ :id => @story.id,  :story => {:description => "bar"}}
          end
        end

        should "redirect to show" do
          assert_redirected_to story_url(assigns(:story))
        end

      end

      context "with invalid parameters" do
        setup do
          put :update, :id => @story.id, :story => {:description => ""}
        end

        should "redisplay the edit template" do
          assert_template "edit"
        end
      end
    end

  end

end

