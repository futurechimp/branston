require 'test_helper'

class IterationsControllerTest < ActionController::TestCase

  context "The IterationsController" do
    context "when the user is not logged in" do
      [:index, :new, :edit].each do |action|
        context "on GET to #{action.to_s}" do
          setup do
            get action
          end

          should "redirect to login" do
            assert_redirected_to new_session_path
          end
        end
      end

      context "on PUT to :update" do
        setup do
          put :update
        end
        should "redirect to login" do
          assert_redirected_to new_session_path
        end
      end

      context "on POST to :create" do
        setup do
          post :create
        end
        should "redirect to login" do
          assert_redirected_to new_session_path
        end
      end
    end

    context "when the user is logged in" do
      setup do
        @user = User.make
        login_as(@user)
      end

      context "when there are no iterations yet" do
        setup do
          get :index
        end

        should "get index" do
          assert_response :success
          assert_not_nil assigns(:iterations)
        end
      end

      context "when at least one iteration exists" do
        setup do
          @iteration = Iteration.make
        end

        context "on GET to index" do
          setup do
            get :index
          end

          should "work" do
            assert_response :success
            assert_not_nil assigns(:iterations)
          end
        end

        should "get edit" do
          get :edit, :id => @iteration.to_param
          assert_response :success
          assert assigns(:releases)
        end

        should "get new" do
          get :new
          assert_response :success
          assert assigns(:releases)
        end


        context "on GET to show" do
          setup do
            get :show, :id => @iteration.to_param
          end
          should "show iteration" do
            assert_response :success
          end
        end

        should "destroy iteration" do
          assert_difference('Iteration.count', -1) do
            delete :destroy, :id => @iteration.to_param
          end

          assert_redirected_to iterations_path
        end

        context "creating an iteration" do
          context "with valid params" do
            setup do
              login_as(@user)
              assert_difference("Iteration.count") do
                post :create, :iteration => Iteration.plan
              end
            end

            should "not be assigned to a release" do
              assert assigns(:iteration).release.nil?
            end

            should "redirect to show" do
              assert_redirected_to iterations_path
            end

            context "including a release_id" do
              setup do
                assert_difference("Iteration.count") do
                  post :create, :iteration => Iteration.plan.merge(:release_id => Release.make.to_param)
                end
              end

              should "be assigned to a release" do
                assert assigns(:iteration).release
              end
            end
          end

          context "with invalid params" do
            setup do
              login_as(@user)
              assert_no_difference("Iteration.count") do
                post :create, :iteration => {}
              end
            end

            should "redisplay" do
              assert_template 'new'
            end

            should "retrieve all releases" do
              assert assigns(:releases)
            end
          end
        end

        context "updating an iteration" do
          context "with valid parameters" do
            setup do
              login_as(@user)
              assert_no_difference("Iteration.count") do
                put :update,{ :id => @iteration.to_param,  :iteration => {:name => "bar"}}
              end
            end

            should "redirect to show" do
              assert_redirected_to iterations_path
            end

            context "including a release_id" do
              setup do
                put :update, :id => @iteration.to_param, :iteration => {:release_id => Release.make.to_param}
              end

              should "be assigned to a release" do
                assert assigns(:iteration).release
              end
            end
          end

          context "with invalid parameters" do
            setup do
              put :update, :id => @iteration.id, :iteration => {:name => ""}
            end

            should "redisplay the edit template" do
              assert_template "edit"
            end

            should "retrieve all releases" do
              assert assigns(:releases)
            end
          end
        end
      end

      context "showing an iteration with 5 stories" do
        setup do
          @iteration = Iteration.make
          5.times do
            @iteration.stories.push Story.make(:completed)
          end
          get :show, :id => @iteration.to_param
        end

        should "work" do
          assert_response :success
        end

        should "successfully respond with iteration data" do
          assert assigns(:iteration)
          assert assigns(:iteration_data)
        end

        should "have 5 stories assigned to it" do
          assert_equal assigns(:iteration).stories.length, 5
        end
      end
    end
  end
end

