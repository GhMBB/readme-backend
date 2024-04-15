# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/email_confirmation
  def email_confirmation
    UserMailer.email_confirmation
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/restore_password
  def restore_password
    UserMailer.restore_password
  end

end
