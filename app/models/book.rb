class Book < ApplicationRecord
    validates :title, :genre, :subgenre, :pages, :copies, presence: true

    enum activated: [:no, :yes]
    after_initialize :set_default_activated, :if => :new_record?
    def set_default_activated
        self.activated ||= :yes
    end

end
