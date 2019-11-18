class Campaign < ApplicationRecord
  validates_uniqueness_of :name
  after_destroy :destroy_requests
  after_destroy :destroy_apps
  has_many :apps

  # before_create :set_access_token

  def name=(val)
    write_attribute(:slug, val.parameterize)
    write_attribute(:name, val)
  end

  private

    def set_access_token
      self.slug = generate_token
    end

    def generate_token
      loop do
        token = SecureRandom.urlsafe_base64(5)
        break token unless Campaign.where(slug: token).exists?
      end
    end

    def destroy_apps
      self.apps.destroy_all
    end
end
