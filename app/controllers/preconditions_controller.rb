class PreconditionsController < ApplicationController
  # GET /preconditions
  # GET /preconditions.xml
  def index
    @preconditions = Precondition.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preconditions }
    end
  end

  # GET /preconditions/1
  # GET /preconditions/1.xml
  def show
    @precondition = Precondition.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @precondition }
    end
  end

  # GET /preconditions/new
  # GET /preconditions/new.xml
  def new
    @precondition = Precondition.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @precondition }
    end
  end

  # GET /preconditions/1/edit
  def edit
    @precondition = Precondition.find(params[:id])
  end

  # POST /preconditions
  # POST /preconditions.xml
  def create
    @precondition = Precondition.new(params[:precondition])

    respond_to do |format|
      if @precondition.save
        flash[:notice] = 'Precondition was successfully created.'
        format.html { redirect_to(@precondition) }
        format.xml  { render :xml => @precondition, :status => :created, :location => @precondition }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @precondition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preconditions/1
  # PUT /preconditions/1.xml
  def update
    @precondition = Precondition.find(params[:id])

    respond_to do |format|
      if @precondition.update_attributes(params[:precondition])
        flash[:notice] = 'Precondition was successfully updated.'
        format.html { redirect_to(@precondition) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @precondition.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preconditions/1
  # DELETE /preconditions/1.xml
  def destroy
    @precondition = Precondition.find(params[:id])
    @precondition.destroy

    respond_to do |format|
      format.html { redirect_to(preconditions_url) }
      format.xml  { head :ok }
    end
  end
end
