class EmailNotification < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum activated: [:no, :yes]
  after_initialize :set_default_activated, :if => :new_record?
  def set_default_activated
      self.activated ||= :yes
  end

end
