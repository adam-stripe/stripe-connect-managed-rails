module ApplicationHelper
  def format_amount(amount)
    sprintf('$%0.2f', amount.to_f / 100.0).gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end

  def format_date(created)
    Time.at(created).getutc.strftime("%m/%d/%Y")
  end
end
