module ApplicationHelper
  def row_class_for_interval(start_date, end_date)
    row_class = "regular"

    if start_date <= Date.today && Date.today <= end_date
      row_class = "current"
    elsif start_date < Date.today && start_date >= (Date.today << 1)
      row_class = "last-month"
    elsif start_date < Date.today
      row_class = "historical"
    end

    row_class
  end

  def cell_class(person_name)
    'warning' if person_name.match?(/tbd/i)
  end

  def prettify_date(date)
    date.strftime("%a, %d %b %Y")
  end
end
