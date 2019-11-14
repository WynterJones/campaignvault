class App < ApplicationRecord
  after_destroy :destroy_requests
  has_many :requests
  belongs_to :campaign
  before_create :update_connected

  def slug=(val)
    write_attribute(:slug, val.parameterize)
  end

  private

    def destroy_requests
      self.requests.destroy_all
    end

    def update_connected
      self.connected = false
    end
end
