class StatisticComponent < ActionView::Component::Base
  validates :name, :total, presence: true

  def initialize(name:, total:, stat:, prepend:, append:)
    @name = name
    @total = total
    @stat = stat
    @prepend = prepend
    @append = append
  end

  private

  attr_reader :name, :total, :stat, :prepend, :append
end
