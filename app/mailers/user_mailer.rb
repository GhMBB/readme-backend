class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_confirmation.subject
  #
  def email_confirmation
    @user = params[:user]
    @greeting = "Hi"
    @code = @user.persona.confirmation_token
    mail to: @user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.restore_password.subject
  #
  def restore_password
    @user = params[:user]
    @greeting = "Hi"
    @reset_code = @user.reset_password_token
    mail to: @user.email
  end
end
