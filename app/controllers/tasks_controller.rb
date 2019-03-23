class TasksController < ApplicationController
  protect_from_forgery except: [:create,:update]
  def show
    @task = Task.find(params[:id])
  end

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

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:info] = "タスクを更新しました"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

    def task_params
      params.require(:task).permit(:task_name, :completed, :due_date)
    end

end
