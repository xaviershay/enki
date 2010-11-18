module DateHelper
  def format_month(date)
    I18n.localize date.to_date, :format => :month_year
  end

  def format_post_date(date)
    I18n.localize date.to_date, :format => :long
  end

  def format_comment_date(date)
    I18n.localize date, :format => :long
  end
end
