module BugsHelper
  def format_text(text)
    text.upcase_first
  end

  def format_date(date)
    date&.strftime("%A, %d %b")
  end
end
