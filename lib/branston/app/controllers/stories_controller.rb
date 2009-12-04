class StoriesController < ApplicationController

  layout 'main'
  before_filter :retrieve_iterations, :only =>  [:new, :edit, :create, :update]

  in_place_edit_for :story, :title
  in_place_edit_for :story, :description
  in_place_edit_for :story, :points

  def generate_feature
    @story = Story.find(params[:id], :include => :scenarios)
    @story.generate(@story)
    render :text => 'done'
  end

  # GET /stories
  # GET /stories.xml
  def index
    @current_stories = Story.in_progress
    @backlog_stories = Story.find :all, :conditions => "iteration_id IS NULL"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stories }
    end
  end

  # GET /stories/1
  # GET /stories/1.xml
  def show
    @story = Story.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => (@story.to_xml :include => { :scenarios => {
      :include => [:preconditions, :outcomes] } } ) }
      format.js { render :partial => 'story' }
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
    @story = Story.find(params[:id])
  end

  # POST /stories
  # POST /stories.xml
  def create
    @story = Story.new(params[:story])

    respond_to do |format|
      if @story.save
        flash[:notice] = 'Story was successfully created.'
        format.html { redirect_to stories_url }
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
    @story = Story.find(params[:id])
    respond_to do |format|
      if @story.update_attributes(params[:story])
        flash[:notice] = 'Story was successfully updated.'
        format.html { redirect_to(@story) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @story.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @story = Story.find(params[:id])
    @story.destroy

    respond_to do |format|
      format.html { redirect_to(stories_url) }
      format.xml  { head :ok }
    end
  end


  private

  def retrieve_iterations
    @iterations = Iteration.all
  end

end

