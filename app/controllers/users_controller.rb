require 'uri'

class UsersController < ApplicationController
  def show
    redirect_to targets_path + "?grid[f][users.email]=#{User.find_by!(username: params[:username]).email}"
  end
end
