class TaskController < ApplicationController
  def index
    @tasks = Task.order(:id).page(params[:page]).per(30)
  end
end
