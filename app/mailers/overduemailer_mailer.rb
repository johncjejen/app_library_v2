class OverduemailerMailer < ApplicationMailer

    def send_mail_overdue
        
        emails_overdue = BorrowBook.where("borrow_books.due_date > ?", DateTime.current.to_date)

        if !emails_overdue.blank?

            emails_overdue.each do |email_overdue|

                mail(to: email_overdue.user.email, subject: "your return date of the book#{email_overdue.book.title} is overdue")

            end
        end
    end

end
