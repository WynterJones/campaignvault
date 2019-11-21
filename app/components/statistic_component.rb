class StatisticComponent < ActionView::Component::Base
  validates :name, :total, presence: true

  def initialize(name:, total:)
    @name = name
    @total = total
  end

  private

  attr_reader :name, :total
end
