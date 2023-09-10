class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def welcome_email
    @user=params[:user]
    mail(to: @user.email, subject: "Welcome To Task Tracker!")
  end

  def reset_password_instructions(user)
    @user = user
    @reset_url = url_for(controller: 'users', action: 'reset_password', token: user.password_reset_token, only_path: false)

    mail(to: user.email, subject: 'Reset Your Password')
  end
end
