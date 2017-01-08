require 'uri'

class UsersController < ApplicationController
  def show
    redirect_to targets_path + "?grid[f][users.email]=#{params[:username]}"
  end
end
