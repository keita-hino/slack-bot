class TasksController < ApplicationController
  protect_from_forgery except: [:create]
  def index
    @tasks = Task.order(updated_at: "desc").page(params[:page]).per(30)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:info] = "タスクを登録しました"
      redirect_to root_url
    else
      render 'new'
    end
  end

  private

    def task_params
      params.require(:task).permit(:task_name, :completed, :due_date)
    end

end
