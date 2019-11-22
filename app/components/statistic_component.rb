class StatisticComponent < ActionView::Component::Base
  validates :name, :total, presence: true

  def initialize(name:, total:, stat:)
    @name = name
    @total = total
    @stat = stat
  end

  private

  attr_reader :name, :total, :stat
end
