class NotifierMailer < ApplicationMailer
    default from: "no-reply@example.com"

def welcome_email(user, bug, project)
  @user = user
  @bug = bug
  @project = project
  mail(to: @user.email, subject: "Welcome to Bug Tracker")
end
end
