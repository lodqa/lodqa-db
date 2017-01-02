class TargetsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :destroy]

  # GET /targets
  # GET /targets.json
  def index
    @targets = Target.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @targets }
    end
  end

  # GET /targets/names.json
  def names
    names = Target.pluck(:name)
    respond_to do |format|
      format.json { render json: names }
    end
  end

  # GET /targets/1
  # GET /targets/1.json
  def show
    @target = Target.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/new
  # GET /targets/new.json
  def new
    @target = Target.new
    @target.sample_queries = @target.sample_queries.join("\n")
    @target.sortal_predicates = @target.sortal_predicates.join("\n")
    @target.ignore_predicates = @target.ignore_predicates.join("\n")

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/1/edit
  def edit
    @target = Target.find(params[:id])
    @target.sample_queries = @target.sample_queries.join("\n")
    @target.sortal_predicates = @target.sortal_predicates.join("\n")
    @target.ignore_predicates = @target.ignore_predicates.join("\n")
  end

  # POST /targets
  # POST /targets.json
  def create
    @target = Target.new(params[:target])
    @target.user = current_user
    @target.sample_queries = @target.sample_queries.split(/[\n\r\t]+/)
    @target.sortal_predicates = @target.sortal_predicates.split(/[\n\r\t]+/)
    @target.ignore_predicates = @target.ignore_predicates.split(/[\n\r\t]+/)

    respond_to do |format|
      if @target.save
        format.html { redirect_to @target, notice: 'Target was successfully created.' }
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html { render action: "new" }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /targets/1
  # PUT /targets/1.json
  def update
    @target = Target.find(params[:id])
    update = params[:target]
    update["sample_queries"] = update["sample_queries"].split(/[\n\r\t]+/)
    update["sortal_predicates"] = update["sortal_predicates"].split(/[\n\r\t]+/)
    update["ignore_predicates"] = update["ignore_predicates"].split(/[\n\r\t]+/)

    respond_to do |format|
      if @target.update_attributes(update)
        format.html { redirect_to @target, notice: 'Target was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /targets/1
  # DELETE /targets/1.json
  def destroy
    @target = Target.find(params[:id])
    @target.destroy

    respond_to do |format|
      format.html { redirect_to targets_url }
      format.json { head :no_content }
    end
  end
end
