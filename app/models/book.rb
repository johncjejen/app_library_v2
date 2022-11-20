class Book < ApplicationRecord
    belongs_to :library
    validates :title, :genre, :subgenre, :pages, :copies, presence: true
    paginates_per 20


    enum activated: [:no, :yes]
    after_initialize :set_default_activated, :if => :new_record?
    def set_default_activated
        self.activated ||= :yes
    end

end
