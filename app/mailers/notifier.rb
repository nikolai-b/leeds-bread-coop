class Notifier < ActionMailer::Base
  default from: "info@leedsbread.coop"

  def new_sub(subscriber)
    template = EmailTemplate.find_by name: 'new_sub'
    email = mail(to: subscriber.email,
         subject: 'New Subscription to Leeds Bread Co-op',
         body: template.body,
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end
end
