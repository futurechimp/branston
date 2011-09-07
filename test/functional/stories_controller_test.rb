require 'test_helper'

class StoriesControllerTest < ActionController::TestCase

  context "The StoriesController" do
    setup do
      @iteration = Iteration.make
      2.times {
        @story = Factory.make_story(:iteration => @iteration)
        @quality_assurance = Factory.make_story(:iteration => @iteration, :status => "quality_assurance")
        @in_progress = Factory.make_story(:iteration => @iteration, :status => "in_progress")
        @completed = Factory.make_story(:iteration => @iteration, :status => "completed")
      }

      @some_other_iteration = Iteration.make
      @later = Story.make(:iteration => @some_other_iteration)
    end

    teardown do
      feature_file = FEATURE_PATH + @story.feature_filename
      FileUtils.rm feature_file if File.exists? feature_file
      step_file = FEATURE_PATH + @story.step_filename
      FileUtils.rm step_file if File.exists? step_file
    end

    context "with a logged-in user" do
      setup do
        @user = User.make
        login_as(@user)
      end

      should "show a list of all the stories in the current iteration" do
        get :index, :iteration_id => @iteration.to_param
        assert_response :success
        assert_not_nil assigns(:backlog_stories)
        assert_not_nil assigns(:completed_stories)
        assert_not_nil assigns(:current_stories)
        assert_not_nil assigns(:quality_assurance_stories)
        assert_equal 2, assigns(:backlog_stories).size
        assert_equal 2, assigns(:completed_stories).size
        assert_equal 2, assigns(:current_stories).size
        assert_equal 2, assigns(:quality_assurance_stories).size
        assert assigns(:backlog_stories).include? @story
        assert assigns(:current_stories).include? @in_progress
        assert assigns(:completed_stories).include? @completed
        assert assigns(:quality_assurance_stories).include? @quality_assurance
        assert_equal 16, assigns(:total_assigned_points)
        assert_equal -34, assigns(:assignment_difference)
      end

      should "show a form to edit stories" do
        get :edit, :id => @story.slug, :iteration_id => @iteration.to_param
        assert_response :success
        assert assigns(:iterations)
      end

      should "show a form to add stories" do
        get :new, :iteration_id => @iteration.to_param
        assert_response :success
        assert assigns(:iterations)
      end

      should "delete a story" do
        assert_difference('Story.count', -1) do
          delete :destroy, :id => @story.slug, :iteration_id => @iteration.to_param
        end

        assert_redirected_to iteration_stories_path(@iteration)
      end

      should "generate the cucumber feature file for a story" do
        get :generate_feature, :id => @story.to_param, :path => 'test/features/',
        	:iteration_id => @iteration.to_param
        assert_response :success
        assert File.exists? FEATURE_PATH + @story.feature_filename
        assert File.exists? FEATURE_PATH + @story.step_filename
      end

      context "creating a story" do
        context "with valid params" do
          setup do
            assert_difference("Story.count") do
              post :create, :story => Story.plan, :iteration_id => @iteration.to_param
            end
          end

          should "redirect to show" do
            assert_redirected_to iteration_stories_path(@iteration)
          end

          should "be associated with an iteration" do
            assert_equal assigns(:story).iteration, @iteration
          end

          should "remember who authored it" do
            assert_equal @user, assigns(:story).author
          end

          context "including an iteration id" do
            setup do
              assert_difference("Story.count") do
                post :create, :story => Story.plan(:in_progress),
                :iteration_id => @iteration.to_param
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
              post :create, :story => {}, :iteration_id => @iteration.to_param
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
              put :update,{ :id => @story.slug,  :story => {:description => "bar"},
              	:iteration_id => @iteration.to_param }
            end
          end

					should "leave the story as new" do
						assert @story.new?
					end

          should "redirect to show" do
            assert_redirected_to iteration_story_path(@iteration, @story)
          end

          context "with story status set to 'in_progress'" do
            setup do
              put :update,{ :id => @story.to_param,  :story => {
                	:description => "bar", :status => "in_progress"
								}, :iteration_id => @iteration.to_param }
            end

            should "set the story's status to 'in_progress'" do
              assert_equal assigns(:story).status, "in_progress"
            end
          end

          context "with story status set to 'quality_assurance'" do
            setup do
              @story.status = "in_progress"
              @story.save
              put :update,{ :id => @story.to_param,  :story => {
                :description => "bar", :status => "quality_assurance"},
              :iteration_id => @iteration.to_param }
            end

            should "set the story's status to 'quality_assurance'" do
              assert_equal assigns(:story).status, "quality_assurance"
            end
          end

          context "with story status set to 'in_progress'" do
            setup do
              @story.status = "in_progress"
              @story.save
              put :update,{ :id => @story.to_param,  :story => {
                :description => "bar", :status => "new"},
              :iteration_id => @iteration.to_param }
            end

            should "set the story's status back to 'new'" do
              assert_equal assigns(:story).status, "new"
            end
          end

          context "with story status set to 'completed'" do
            setup do
              @story.status = "quality_assurance"
              @story.save
              put :update,{ :id => @story.to_param,  :story => {
                :description => "bar", :status => "completed"},
              :iteration_id => @iteration.to_param }
            end

            should "set the story's status to 'completed'" do
              assert_equal assigns(:story).status, "completed"
            end
          end
        end

        context "with invalid parameters" do
          setup do
            put :update, :id => @story.slug, :story => {:description => ""},
            :iteration_id => @iteration.to_param
          end

          should "redisplay the edit template" do
            assert_template "edit"
            assert assigns(:iterations)
          end
        end
      end
    end

    context "when a request comes from the Branston client" do
      setup do
        @user = User.make
      end

      context "with a username and password" do
        setup do
          get :show,
            :id => @story.slug, :iteration_id => @iteration.to_param,
            :username => @user.login, :password => "password"
        end

        should "show details about a story" do
          assert_response :success
          assert assigns(:story)
          assert_match /#{@story.description.gsub('"', "&quot;")}/, @response.body
        end
      end

      context "where the the slug is not found" do
        setup do
          @user = User.make
          get :show,
            :id => 'none-such-story', :iteration_id => @iteration.to_param,
            :username => @user.login, :password => "monkey"
        end

        should "fail gracefully" do
          assert_response 404
        end
      end

      context "without a username and password" do
        setup do
          get :show,
            :id => @story.to_param, :iteration_id => @iteration.to_param
        end

        should "fail gracefully" do
          get :show, :id => 'none-such-story', :iteration_id => @iteration.to_param
          assert_response 404
        end
      end

    end
  end
end

