class TasksController < ApplicationController
  before_action :set_tasks_params, only: %i[show update destroy]

  def create
    @tasks = Task.new(tasks_params)
    if @tasks.save
      render json: { message: 'Task Created Successfully', tasks: @tasks }, status: :created
    else
      render json: { errors: @tasks.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @tasks, status: :ok
  end

  def update
    if @tasks.update(tasks_params)
      render json: { message: 'Task Updated Successfully', tasks: @tasks }, status: :ok
    else
      render json: { errors: @tasks.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @tasks.destroy
      render json: { message: 'Task Deleted Successfully' }, status: :ok
    else
      render json: { errors: @tasks.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_tasks_params
    @tasks = Task.find(params[:id])
  end

  def tasks_params
    params.require(:task).permit(:url, :status)
  end  
end
