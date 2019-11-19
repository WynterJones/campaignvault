class Campaign < ApplicationRecord
  validates_uniqueness_of :name
  after_destroy :destroy_apps
  has_many :apps

  def name=(val)
    write_attribute(:slug, val.parameterize)
    write_attribute(:name, val)
  end

  private

    def destroy_apps
      self.apps.destroy_all
    end
end
