require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase

  context "The ProjectsController" do

  	setup do
  		@project = Project.make
  	end

		context 'GET to index' do
		  setup do
		    get :index
		  end
		  should_respond_with :success
		  should_assign_to :projects
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
            post :create, :project => {  }
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

