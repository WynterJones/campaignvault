class StatisticComponent < ActionView::Component::Base
  validates :name, :total, presence: true

  def initialize(name:, total:, max_total:)
    @name = name
    @total = total
    @max_total = max_total
  end


  private

  attr_reader :name, :total, :max_total
end
