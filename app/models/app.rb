class App < ApplicationRecord
  after_destroy :destroy_requests
  has_many :databases
  belongs_to :campaign

  def name=(val)
    write_attribute(:slug, val.parameterize)
    write_attribute(:name, val)
  end

  private

    def destroy_requests
      self.databases.destroy_all
    end
end
