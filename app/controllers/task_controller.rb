class TaskController < ApplicationController
  def index
    @tasks = Task.order(updated_at: "desc").page(params[:page]).per(30)
  end
end
