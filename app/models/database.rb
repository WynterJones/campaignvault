class Database < ApplicationRecord
  after_destroy :destroy_requests
  has_many :requests
  belongs_to :app
  before_create :update_connected

  def name=(val)
    write_attribute(:slug, val.parameterize)
    write_attribute(:name, val)
  end

  private

    def destroy_requests
      self.requests.destroy_all
    end

    def update_connected
      self.connected = false
    end
end
