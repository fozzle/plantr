desc "This task sends daily reminders about plant tasks."
task :send_plant_reminders => :environment do
  @twilio_client = Twilio::REST::Client.new ENV["TWILIO_SID"], ENV["TWILIO_TOKEN"]

  tasks = Task.all

  tasks.each do |task|
    if task.schedule.occurs_on?(Date.today)
      twilio_phone_number = task.plant.garden.phone
      return if twilio_phone_number.empty?

      task.plant.garden.users.each do |user|
        next if user.phone.nil?

        @twilio_client.account.sms.messages.create(
          :from => "#{twilio_phone_number}",
          :to => "#{user.phone}",
          :body => "Reminder for your #{task.plant.name.downcase.pluralize}: #{task.description}"
        )
      end
    end
  end
end