class ChartComponent < ActionView::Component::Base
  validates :title, :graph, presence: true

  def initialize(title:, graph:)
    @title = title
    @graph = graph
  end

  private

  attr_reader :title, :graph
end
