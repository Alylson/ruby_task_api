class TasksController < ApplicationController
  before_action :set_tasks_params, only: %i[show update destroy]

  def index
    @tasks = Task.all

    render json: { tasks: @tasks }, status: :ok
  end

  def create
    @tasks = Task.new(tasks_params)
    if @tasks.save
      ActiveSupport::Notifications.instrument('task.created', task: task, user: current_user)

      start_scraping(@task)

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

  def start_scraping(task)
    scraping_api_url = Rails.application.credentials.url_scraping
    scraping_request_url = "#{scraping_api_url}?url=#{@task.url}"

    response = Faraday.post(scraping_api_url)

    if response.success?
      Rails.logger.info "Scraping started for the task #{task.id}"
    else
      Rails.logger.error "Error starting scraping: #{response.body}"
    end
  end
  
  def tasks_params
    params.require(:task).permit(:url, :status)
  end  
end
