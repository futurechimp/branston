class ProjectsController < ApplicationController

  before_filter :login_required

  layout 'main'

  def index
    if current_user
      if current_user.role == 'client'
        @projects = current_user.projects
      else
        @projects = Project.all
      end

      respond_to do |format|
        format.html
        format.xml  { render :xml => @projects }
      end
    else
      redirect_to '/sessions/new'
    end
  end

  def show
    @project = Project.find(params[:id])
    @page_title = @project.name
		@iterations = Iteration.find(:all, :conditions => ["project_id = ?", params[:id]])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if Project.permit?(current_user.role, :create) && @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if Project.permit?(current_user.role, :update) && @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy if Project.permit?(current_user.role, :destroy)

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
