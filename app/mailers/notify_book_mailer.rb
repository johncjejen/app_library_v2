class NotifyBookMailer < ApplicationMailer

    def send_mail_notify
        
        @user = params[:user]
        @book = params[:book]

        mail(to: @user.email, subject: "The book #{@book.title} is Available")

    end

end
