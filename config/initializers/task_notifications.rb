ActiveSupport::Notifications.subscribe('task.created') do |name, start, finish, id, payload|
  task = payload[:task]

  Rails.logger.info "Notifying about task #{task.id}"

  response = Faraday.post(ENV['URL_NOTIFICATION'], { task_id: task.id }.to_json, "Content-Type" => "application/json")

  if response.success?
    Rails.logger.info "Notification sent to Notifications API successfully!"
  else
    Rails.logger.error "Error sending notification: #{response.body}"
  end
end
