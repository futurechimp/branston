require 'test_helper'

class StoriesControllerTest < ActionController::TestCase

  context "The StoriesController" do
    setup do
      @story = Factory.make_story
    end

    teardown do
      feature_file = 'test/features/' + @story.feature_filename
      FileUtils.rm feature_file if File.exists? feature_file
    end

    should "show a list of all the stories" do
      get :index
      assert_response :success
      assert_not_nil assigns(:backlog_stories)
    end

    should "show a form to edit stories" do
      get :edit, :id => @story.to_param
      assert_response :success
      assert assigns(:iterations)
    end

    should "show a form to add stories" do
      get :new
      assert_response :success
      assert assigns(:iterations)
    end

    should "show details about a story" do
      get :show, :id => @story.to_param
      assert_response :success
    end

    should "delete a story" do
      assert_difference('Story.count', -1) do
        delete :destroy, :id => @story.to_param
      end

      assert_redirected_to stories_path
    end

    should "generate the cucumber feature file for a story" do
      get :generate_feature, :id => @story.to_param, :path => 'test/features/'
      assert_response :success
      assert File.exists? FEATURE_PATH + @story.feature_filename
      assert File.exists? FEATURE_PATH + @story.step_filename
    end

    context "creating a story" do

      context "with valid params" do
        setup do
          assert_difference("Story.count") do
            post :create, :story => Story.plan
          end
        end

        should "redirect to show" do
          assert_redirected_to stories_path
        end

        should "not be associated with an iteration" do
          assert !assigns(:story).iteration
        end

        context "including an iteration id" do
          setup do
            assert_difference("Story.count") do
              post :create, :story => Story.plan(:in_progress)
            end
          end

          should "be associated with an iteration" do
            assert assigns(:story).iteration
          end
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
          assert assigns(:iterations)
        end
      end
    end

    context "updating a story" do
      context "with valid parameters" do
        setup do
          assert_no_difference("Story.count") do
            put :update,{ :id => @story.to_param,  :story => {:description => "bar"}}
          end
        end

        should "redirect to show" do
          assert_redirected_to story_url(assigns(:story))
        end

      end

      context "with invalid parameters" do
        setup do
          put :update, :id => @story.to_param, :story => {:description => ""}
        end

        should "redisplay the edit template" do
          assert_template "edit"
          assert assigns(:iterations)
        end
      end
    end

  end

end

