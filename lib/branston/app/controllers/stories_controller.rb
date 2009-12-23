class StoriesController < ApplicationController
  
  layout 'main'
  before_filter :login_required, :except => [:show, :generate_feature]
  before_filter :retrieve_iterations, :except => [:generate_feature]
  before_filter :load_iteration
  
  in_place_edit_for :story, :title
  in_place_edit_for :story, :description
  in_place_edit_for :story, :points
  
  def generate_feature
    @story = Story.find_by_slug(params[:id])
    if @story.nil?
      @story = Story.find(:first, :include => :scenarios, 
        :conditions => ['slug LIKE ?', "%#{id}%"] )
    end
    @story.generate(@story)
    render :text => 'done'
  end
    
  # GET /stories
  # GET /stories.xml
  def index
    @current_stories = Story.for_iteration(@iteration.id).in_progress
    @backlog_stories = Story.for_iteration(@iteration.id).unassigned
    @completed_stories = Story.for_iteration(@iteration.id).completed
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end
  
  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find_by_slug(params[:id])
    
    respond_to do |format|
      if @story
        format.html # show.html.erb
        format.xml  {
          render :xml => (@story.to_xml :include => { :scenarios => {
        :include => [:preconditions, :outcomes] } } ) }
          format.js { @active = true }
        else
          format.html { render_optional_error_file 404 } 
          format.all  { render :nothing => true, :status => 404 }
        end
      end
    end
    
    # GET /stories/new
    # GET /stories/new.xml
    def new
      @story = Story.new
      
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @story }
      end
    end
    
    # GET /stories/1/edit
    def edit
      @story = Story.find_by_slug(params[:id])
    end
    
    # POST /stories
    # POST /stories.xml
    def create
      @story = Story.new(params[:story])
      @story.author = current_user
      
      respond_to do |format|
        if @story.save
          flash[:notice] = 'Story was successfully created.'
          format.html { redirect_to iteration_stories_url(@iteration) }
          format.xml  { render :xml => @story, :status => :created, :location => @story }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
        end
      end
    end
    
    # PUT /stories/1
    # PUT /stories/1.xml
    def update
      @story = Story.find_by_slug(params[:id])
      respond_to do |format|
        if @story.update_attributes(params[:story])
          flash[:notice] = 'Story was successfully updated.'
          format.html { redirect_to iteration_story_path(@iteration, @story) }
          format.xml  { head :ok }
          format.js { redirect_to iteration_stories_path(@iteration) }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
        end
      end
    end
    
    # DELETE /stories/1
    # DELETE /stories/1.xml
    def destroy
      @story = Story.find_by_slug(params[:id])
      @story.destroy
      
      respond_to do |format|
        format.html { redirect_to iteration_stories_path(@iteration) }
        format.xml  { head :ok }
      end
    end
    
    
    private
    
    def retrieve_iterations
      @iterations = Iteration.all
    end
    
    def load_iteration
      @iteration = Iteration.find(params[:iteration_id])
    end    
  end
  

