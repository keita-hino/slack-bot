module ApplicationHelper
  def show_dat(time)
    return time unless time
    time.strftime("%Y/%m/%d")
  end
end
