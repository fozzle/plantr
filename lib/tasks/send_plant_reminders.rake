desc "This task sends daily reminders about plant tasks."
task :send_plant_reminders => :environment do
  twilio_sid = "AC3d33aec0094782093e058f29c5093856"
  twilio_token = "c7151b10ee5ad0318135974ad31e8cae"
  @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

  tasks = Task.all

  tasks.each do |task|
    if task.schedule.occurs_on?(Date.today)
      twilio_phone_number = task.plant.garden.phone
      return if twilio_phone_number.empty?

      task.plant.garden.users.each do |user|
        next if user.phone.nil?

        @twilio_client.account.sms.messages.create(
          :from => "+1#{twilio_phone_number}",
          :to => "#{user.phone}",
          :body => "Reminder for your #{task.plant.name.pluralize}: #{task.description}"
        )
      end
    end
  end
end