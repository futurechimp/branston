class ScenariosController < ApplicationController

  layout 'main'

  before_filter :find_story, :except => [:destroy, :set_scenario_title]

  in_place_edit_for :scenario, :title

  def index
    @scenarios = @story.scenarios
    respond_to do |format|
      format.html
      format.js { render :partial => "scenarios" }
    end
  end

  # GET /scenarios/1
  # GET /scenarios/1.xml
  def show
    @scenario = Scenario.find(params[:id])

    respond_to do |format|
      format.html # scenario.html.erb
      format.xml  { render :xml => @scenario }
    end
  end

  # GET /stories/:story_id/scenarios/new
  # GET /stories/:story_id/scenarios/new.xml
  def new
    @scenario = Scenario.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @story }
      format.js   { render :partial => "scenario" }
    end
  end


  # GET /scenarios/1/edit
  def edit
    @scenario = Scenario.find(params[:id])
  end

  # POST /stories/:story_id/scenarios
  # POST /stories/:story_id/scenarios.xml
  def create
    @scenario = Scenario.new(params[:scenario])
    @scenario.story = @story
    respond_to do |format|
      if @scenario.save
        @scenarios = @story.scenarios
        flash[:notice] = 'Scenario was successfully created.'
        format.html { redirect_to story_scenario_path(@story, @scenario) }
        format.xml  { render :xml => @scenario, :status => :created, :location => @scenario }
        format.js
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /scenarios/1
  # PUT /scenarios/1.xml
  def update
    @scenario = Scenario.find(params[:id])
    respond_to do |format|
      if @scenario.update_attributes(params[:scenario])
        flash[:notice] = 'Scenario was successfully updated.'
        format.html { redirect_to story_scenario_path(@story, @scenario) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @scenario.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stories/1
  # DELETE /stories/1.xml
  def destroy
    @scenario = Scenario.find(params[:id])
    @scenario.destroy

    respond_to do |format|
      format.html { redirect_to(stories_path) }
      format.xml  { head :ok }
      format.js
    end
  end


  private

  def find_story
    @story = Story.find(params[:story_id]) if @story.nil?
  end

end

