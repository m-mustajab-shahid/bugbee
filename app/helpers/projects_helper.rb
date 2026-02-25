module ProjectsHelper
  def format_date(date)
    date&.strftime("%A,%d %b")
  end
end
