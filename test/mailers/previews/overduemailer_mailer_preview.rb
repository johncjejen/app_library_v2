# Preview all emails at http://localhost:3000/rails/mailers/overduemailer_mailer
class OverduemailerMailerPreview < ActionMailer::Preview

    def overdue_book
        OverduemailerMailer.send_mail_overdue
      end

end
