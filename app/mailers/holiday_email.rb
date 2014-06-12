class HolidayEmail < ActionMailer::Base
  default from: "info@leedsbread.coop"

  def send_this(attrs)
    subscriber_name = attrs[:subscriber_name]
    subscriber_path = attrs[:subscriber_path]
    email = mail(to: "info@leedsbread.coop",
                 subject: "#{subscriber_name} is going on holiday",
         body: "<a href=\"#{subscriber_path}\">#{subscriber_name}</a> is going on holiday from #{attrs[:from_date]} untill #{attrs[:to_date]}",
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end
end
