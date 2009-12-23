require 'test_helper'

class StoriesControllerTest < ActionController::TestCase
  
  context "The StoriesController" do
    setup do
      @story = Factory.make_story
      @in_progress = Factory.make_story(:status => "in_progress")
      @completed = Factory.make_story(:status => "completed")
    end
    
    context "with a logged-in user" do
      setup do
        @user = User.make
        login_as(@user)
      end
      
      teardown do
        feature_file = FEATURE_PATH + @story.feature_filename
        FileUtils.rm feature_file if File.exists? feature_file
        step_file = FEATURE_PATH + @story.step_filename
        FileUtils.rm step_file if File.exists? step_file
      end
      
      should "show a list of all the stories" do
        get :index
        assert_response :success
        assert_not_nil assigns(:backlog_stories)
        assert_not_nil assigns(:completed_stories)
        assert_not_nil assigns(:current_stories)
        assert_equal 1, assigns(:backlog_stories).size
        assert_equal 1, assigns(:completed_stories).size
        assert_equal 1, assigns(:current_stories).size
        assert assigns(:backlog_stories).include? @story
        assert assigns(:current_stories).include? @in_progress
        assert assigns(:completed_stories).include? @completed
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
          
          should "be associated with an iteration" do
            assert assigns(:story).iteration
          end
          
          should "remember who authored it" do
            assert_equal @user, assigns(:story).author
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
    
    context "Without logging in, the StoriesController" do
      
      should "show details about a story" do
        get :show, :id => @story.to_param
        assert_response :success
      end
      
      should "fail gracefully if the slug is not found" do
        get :show, :id => 'none-such-story'
        assert_response 404
      end
    end 
    
  end
end
