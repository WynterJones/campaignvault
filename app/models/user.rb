class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  has_many :settings
  has_many :apps
  has_many :campaigns
  has_many :databases
  has_many :requests

  after_create :set_settings

  def set_settings
    user = self
    settings = Setting.new
    settings.date_format = '%m/%d/%y - %l:%M %p'
    settings.timezone = 'Eastern Time (US & Canada)'
    settings.user_id = user.id
    settings.save!
  end
end
