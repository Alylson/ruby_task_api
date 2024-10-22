require 'faraday'

ActiveSupport::Notifications.subscribe('task.created') do |name, start, finish, id, payload|
  task = payload[:task]
  #user = payload[:user]

  Rails.logger.info "Notifying about task #{task.id}"

  # notification_payload = {
  #   task_id: task.id,
  #   task_url: task.url,
  #   task_status: task.status
  #   #user_id: user.id,
  #   #user_name: user.name,
  #   #user_email: user.email
  # }

  response = Faraday.post(ENV['URL_NOTIFICATION'], { task_id: task.id, message: 'New task created!' }.to_json, "Content-Type" => "application/json")

  if response.success?
    Rails.logger.info "Notification sent to Notifications API successfully!"
  else
    Rails.logger.error "Error sending notification: #{response.body}"
  end
end
