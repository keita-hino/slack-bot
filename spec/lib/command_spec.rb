require 'rails_helper'

describe Command do
  describe '#report' do
    it 'is output report correct' do
      message = {
          channel:"C999999",
          text: "成功",
          as_user: false
      }
      expect(Command.report("C999999")).to eq(message)
    end
  end

end
