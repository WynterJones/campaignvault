class DatePickerComponent < ActionView::Component::Base
  validates :url, presence: true

  def initialize(url:)
    @url = url
  end

  private

  attr_reader :url
end
