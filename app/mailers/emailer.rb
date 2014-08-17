class Emailer < ActionMailer::Base
  default from: "info@leedsbread.coop"

  def send_mail(options)
    email = mail(options)
    email.deliver
  end
end

