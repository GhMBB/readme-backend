class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.email_confirmation.subject
  #
  def ban_notification
    @user = params[:user]
    @greeting = "Hi"
    mail to: @user.email
  end

  def delete_book_notification
    @user = params[:user]
    @book = params[:book]
    @greeting = "Hi"
    mail to: @user.email
  end

  def delete_comment_notification
    @user = params[:user]
    @comment = params[:comment]
    @greeting = "Hi"
    mail to: @user.email
  end
  
  def desban_notification
    @user = params[:user]
    @greeting = "Hi"
    mail to: @user.email
  end

  def desban_rejected_notification
    @user = params[:user]
    @greeting = "Hi"
    mail to: @user.email
  end


  def chapter_notification
    @user = params[:user]
    @capitulo = params[:capitulo]
    @libro = params[:libro]
    mail to: @user.email, subject: "¡Nuevo capítulo publicado en #{@libro.titulo}!"
  end
  



end
