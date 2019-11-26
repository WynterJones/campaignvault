class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  has_many :settings
  has_many :apps
  has_many :campaigns
  has_many :databases
  has_many :requests
  after_create :set_settings
  before_create :generate_token

  def set_settings
    user = self
    settings = Setting.new
    settings.date_format = '%m/%d/%y - %l:%M %p'
    settings.timezone = 'Eastern Time (US & Canada)'
    settings.user_id = user.id
    settings.save!
  end

  protected

    def generate_token
      self.token = SecureRandom.base64(5).tr('+/=', '0aZ')
      generate_token if User.exists?(token: self.token)
    end
end
