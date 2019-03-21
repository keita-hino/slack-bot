module TaskHelper
  def complete(completed)
    if completed
      return "完了"
    else
      return "未完了"
    end
  end
end
