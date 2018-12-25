class Command
  def self.report(channel_id)
    {
        channel:channel_id,
        text: "成功",
        as_user: false
    }
  end
end
