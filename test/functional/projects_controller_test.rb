require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  context "The ProjectsController" do

  	setup do
  		@project = Project.make
      @admin = User.make(:admin)
      @client = User.make(:role => 'client')
      login_as(@admin)
  	end

		context 'GET to index' do
		  setup do
		    3.times do
		      iteration = Iteration.make
		      @project.iterations << iteration
		    end
		    get :index
		  end
		  should_respond_with :success
		  should_assign_to :projects
		  
		  should "show the projects visible to the current user" do
		    assert_equal assigns(:projects).size, Project.count
		  end
		end
		
		context 'GET to index as a non-participating user' do
		  setup do
		    login_as(@client)
		    get :index
		  end
		  should "not show projects where the current user is not a participant" do
		    assert_equal assigns(:projects).size, 0
		  end
		end
		
	  context 'GET to index as a participating user' do
		  setup do
		    3.times do
		      iteration = Iteration.make
		      iteration.geeks << @client
		      @project.iterations << iteration
		    end
		    login_as(@client)
		    get :index
		  end
		  should "not show projects where the current user is not a participant" do
		    assert_equal 1, assigns(:projects).size
		  end
		end

		context 'GET to new' do
		  setup do
		    get :new
		  end

		  should_respond_with :success
		  should_render_template :new
		  should_assign_to :project
		end

		context 'POST to create' do
		  context "with valid parameters" do
        setup do
         assert_difference('Project.count') do
            post :create, :project => { :name => 'Chicken Village', 
              :description => 'A village where chickens rule the roost.' }
          end
        end

        should_redirect_to("the show page") { project_path(assigns(:project))}
        should_assign_to :project
      end

#      context "with invalid parameters" do
#        setup do
#         assert_no_difference('Project.count') do
#            post :create, :project => {}
#          end
#        end

#        should_respond_with :success
#        should_render_template :new
#        should_assign_to :project
#      end
		end

		context 'GET to show' do
		  setup do
		    get :show, :id => @project.to_param
		  end
		  should_respond_with :success
		  should_render_template :show
		  should_assign_to :project
		end

		context 'GET to edit' do
		  setup do
		    get :edit, :id => @project.to_param
		  end
		  should_respond_with :success
		  should_render_template :edit
		  should_assign_to :project
		end

		context 'PUT to update' do
      context "with valid parameters" do
        setup do
          assert_no_difference("Project.count") do
            put :update, :id => @project.to_param, :project => {}
          end
        end

        should_redirect_to("the show page") { project_path(assigns(:project))}
        should_assign_to :project
      end

#      context "with invalid parameters" do
#        setup do
#          assert_no_difference("Project.count") do
#            put :update, :id => @project.to_param, :project => { }
#          end
#        end

#        should_respond_with :success
#        should_render_template :edit
#        should_assign_to :project
#      end
		end

		context 'DELETE to destroy' do
		  setup do
        assert_difference('Project.count', -1) do
          delete :destroy, :id => @project.to_param
        end
      end

      should_redirect_to ("the index page") { projects_path }
		end
  end
end

