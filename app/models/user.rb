class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  has_many :settings
  has_many :apps
  has_many :campaigns
  has_many :databases
  has_many :requests

  after_create :set_settings

  def campaign_limit=(val)
    if !val.present?
      write_attribute(:campaign_limit, 0)
    end
  end

  def app_limit=(val)
    if !val.present?
      write_attribute(:app_limit, 0)
    end
  end

  def database_limit=(val)
    if !val.present?
      write_attribute(:database_limit, 0)
    end
  end

  def request_limit=(val)
    if !val.present?
      write_attribute(:request_limit, 0)
    end
  end

  def set_settings
    user = self
    settings = Setting.new
    settings.date_format = '%m/%d/%y - %l:%M %p'
    settings.timezone = 'Eastern Time (US & Canada)'
    settings.user_id = user.id
    settings.save!
  end
end
