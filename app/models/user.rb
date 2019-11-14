class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  has_many :settings

  after_create :set_settings

  def set_settings
    user = self
    settings = Setting.new
    settings.date_format = 'MM/DD/YY HH:MM PM'
    settings.timezone = 'Eastern Time (US & Canada)'
    settings.user_id = user.id
    settings.save!
  end
end
