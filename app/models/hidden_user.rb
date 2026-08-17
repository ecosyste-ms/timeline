class HiddenUser < ApplicationRecord
  before_validation :normalize_login

  validates :login, presence: true, uniqueness: true

  def self.hidden?(login)
    return false if login.blank?

    exists?(login: login.downcase)
  end

  def normalize_login
    self.login = login&.downcase
  end
end
