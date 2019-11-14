module ApplicationHelper
  def current_class?(test_path)
    request.path == test_path ? 'active' : ''
  end

  def timeframe(time)
    if time.present?
      if time == '7-days'
        output = 1.week.ago
      elsif time == '30-days'
        output = 1.month.ago
      elsif time == '90-days'
        output = 3.month.ago
      elsif time == '1-year'
        output = 1.year.ago
      elsif time == 'all-time'
        output = 5.years.ago
      end
    else
      output = 1.month.ago
    end
    return output
  end
end
