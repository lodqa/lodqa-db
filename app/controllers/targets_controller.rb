class TargetsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit, :destroy]

  # GET /targets
  # GET /targets.json
  def index
    conditions =  if current_user.present?
      if current_user.root
        []
      else
        ["publicity = ? OR user_id = ?", true, current_user.id]
      end
    else
      ["publicity = ?", true]
    end

    @targets_grid = initialize_grid(
      Target,
      conditions: conditions,
      include: :user
    )

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: Target.where(publicity: true) }
    end
  end

  # GET /targets/names.json
  def names
    names = Target.where(publicity: true).pluck(:name)
    respond_to do |format|
      format.json { render json: names }
    end
  end

  # GET /targets/1
  # GET /targets/1.json
  def show
    @target = Target.find_by!(name: params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/new
  # GET /targets/new.json
  def new
    @target = Target.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @target }
    end
  end

  # GET /targets/1/edit
  def edit
    @target = Target.find_by!(name: params[:id])
  end

  # POST /targets
  # POST /targets.json
  def create
    @target = Target.new(target_params)
    @target.user = current_user

    respond_to do |format|
      if @target.save
        format.html { redirect_to @target, notice: 'Target was successfully created.' }
        format.json { render json: @target, status: :created, location: @target }
      else
        format.html {
          render action: "new"
        }
        format.json { render json: @target.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /targets/1
  # PUT /targets/1.json
  def update
    @target = Target.find_by!(name: params[:id])

    respond_to do |format|
      if @target.update_attributes(target_params)
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
    @target = Target.find_by!(name: params[:id])
    @target.destroy

    respond_to do |format|
      format.html { redirect_to targets_url }
      format.json { head :no_content }
    end
  end

  private

  def target_params
    params[:target].permit(
      :description,
      :user,
      :dictionary_url,
      :pred_dictionary_url,
      :endpoint_url, :graph_uri,
      :home,
      :max_hop,
      :name,
      :parser_url,
      :publicity,
      :ignore_predicates_for_view,
      :sortal_predicates_for_view,
      :sample_queries_for_view
    )
  end
end
