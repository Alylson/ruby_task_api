require 'faraday'

ActiveSupport::Notifications.subscribe('task.created') do |name, start, finish, id, payload|
  task = payload[:task]
  user = payload[:user]

  notification_payload = {
    task_id: task.id,
    task_url: task.url,
    task_status: task.status,
    user_id: user.id,
    user_name: user.name,
    user_email: user.email
  }

  response = Faraday.post(Rails.application.credentials.url_notification, notification_payload)

  if response.success?
    Rails.logger.info "Notification sent to Notifications API successfully!"
  else
    Rails.logger.error "Error sending notification: #{response.body}"
  end
end
