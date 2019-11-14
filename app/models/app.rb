class App < ApplicationRecord
  after_destroy :destroy_requests
  has_many :requests
  belongs_to :campaign

  def slug=(val)
    write_attribute(:slug, val.parameterize)
  end

  private

    def destroy_requests
      self.requests.destroy_all
    end
end
