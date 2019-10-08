class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :verify_access, only: %i[edit update destroy]
  skip_before_action :require_login, only: %i[index show]

  def index
    @tasks = Task.all
  end

  def show; end

  def new
    @task = Task.new
  end

  def edit; end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'Task was successfully destroyed.'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content, :status, :deadline)
  end

  def verify_access
    redirect_to root_url, alert: 'Forbidden access.' unless current_user.my_object?(@task)
  end
end
