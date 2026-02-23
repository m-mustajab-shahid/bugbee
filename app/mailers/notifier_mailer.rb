class NotifierMailer < ApplicationMailer
    default from: "no-reply@example.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Bug Tracker")
  end
end
