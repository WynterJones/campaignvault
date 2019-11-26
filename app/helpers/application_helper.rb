module ApplicationHelper
  def get_logo()
    if Setting.find_by(user_id: 1).logo.present?
      logo_url = Setting.find_by(user_id: 1).logo
    else
      logo_url = "logo-dark.png"
    end
    return logo_url
  end

  def check_campaign_limit()
    return current_user.campaign_limit.to_i != 0 && Campaign.where(user_id: current_user.id).count >= current_user.campaign_limit.to_i
  end

  def check_app_limit()
    return current_user.app_limit.to_i != 0 && App.where(user_id: current_user.id).count >= current_user.app_limit.to_i
  end

  def check_database_limit()
    return current_user.database_limit.to_i != 0 && Database.where(user_id: current_user.id).count >= current_user.database_limit.to_i
  end

  def check_request_limit()
    return current_user.request_limit.to_i != 0 && Request.where(user_id: current_user.id).count >= current_user.request_limit.to_i
  end

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

  def is_integer?
    self.to_i.to_s == self
  end

  def is_numeric?(i)
    i.to_i.to_s == i || i.to_f.to_s == i
  end

  def is_float?(object)
    true if Float(object) rescue false
  end

  def percent_of(n)
    self.to_f / n.to_f * 100.0
  end
end
