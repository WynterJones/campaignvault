class Campaign < ApplicationRecord
  validates_uniqueness_of :name
  has_many :webhooks
  has_many :requests

  before_create :set_access_token

  private

    def set_access_token
      self.slug = generate_token
    end

    def generate_token
      loop do
        token = SecureRandom.hex(5)
        break token unless Campaign.where(slug: token).exists?
      end
    end
end
